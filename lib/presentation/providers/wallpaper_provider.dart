import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/wallpaper_model.dart';
import '../../data/services/waifu_feed_service.dart';

// ── Service singleton ─────────────────────────────────────────────────────────
final waifuFeedServiceProvider =
  Provider<WaifuFeedService>((_) => WaifuFeedService());

// ── State ─────────────────────────────────────────────────────────────────────
class WallpaperListState {
  final List<WallpaperModel> wallpapers;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const WallpaperListState({
    this.wallpapers = const [],
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  WallpaperListState copyWith({
    List<WallpaperModel>? wallpapers,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? error,
    bool clearError = false,
  }) {
    return WallpaperListState(
      wallpapers: wallpapers ?? this.wallpapers,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ── Notifier (paginated list) ─────────────────────────────────────────────────
class WallpaperListNotifier extends StateNotifier<WallpaperListState> {
  final WaifuFeedService _service;
  final String _sorting;
  static const String _homeFeedCachePrefix = 'home_feed_v1_';

  WallpaperListNotifier(this._service, this._sorting)
      : super(const WallpaperListState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    await _loadFirstPage(useCache: true);
  }

  Future<void> _loadFirstPage({required bool useCache}) async {
    state = const WallpaperListState(isLoading: true);

    if (useCache) {
      final cached = await _readCachedFirstPage();
      if (cached.isNotEmpty) {
        state = WallpaperListState(
          wallpapers: cached,
          isLoading: false,
          currentPage: 1,
          hasMore: true,
        );
        return;
      }
    }

    try {
      final wallpapers =
          await _service.getWallpapers(sorting: _sorting, page: 1);

      await _writeCachedFirstPage(wallpapers);

      state = WallpaperListState(
        wallpapers: wallpapers,
        isLoading: false,
        currentPage: 1,
        hasMore: wallpapers.length >= AppConstants.pageSize,
      );
    } catch (e) {
      state = WallpaperListState(
        isLoading: false,
        hasMore: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    try {
      final nextPage = state.currentPage + 1;
      final more =
          await _service.getWallpapers(sorting: _sorting, page: nextPage);
      // Deduplicate by ID
      final existingIds = {for (final w in state.wallpapers) w.id};
      final fresh = more.where((w) => !existingIds.contains(w.id)).toList();
      state = state.copyWith(
        wallpapers: [...state.wallpapers, ...fresh],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: more.length >= AppConstants.pageSize,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> refresh() => _loadFirstPage(useCache: false);

  Future<List<WallpaperModel>> _readCachedFirstPage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_homeFeedCachePrefix$_sorting');
      if (raw == null || raw.isEmpty) return const [];

      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(WallpaperModel.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _writeCachedFirstPage(List<WallpaperModel> wallpapers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = jsonEncode(wallpapers.map((w) => w.toJson()).toList());
      await prefs.setString('$_homeFeedCachePrefix$_sorting', payload);
    } catch (_) {
      // Ignore cache persistence errors and keep network data path working.
    }
  }
}

/// Family provider: one notifier per sorting key (hot / toplist / date_added / random).
final wallpaperListProvider = StateNotifierProvider.family<
    WallpaperListNotifier, WallpaperListState, String>(
  (ref, sorting) =>
      WallpaperListNotifier(ref.read(waifuFeedServiceProvider), sorting),
);

// ── Search notifier ───────────────────────────────────────────────────────────
class SearchNotifier extends StateNotifier<WallpaperListState> {
  final WaifuFeedService _service;
  String _currentQuery = '';

  SearchNotifier(this._service)
      : super(const WallpaperListState(isLoading: false));

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _currentQuery = '';
      state = const WallpaperListState(isLoading: false);
      return;
    }
    _currentQuery = trimmed;
    state = const WallpaperListState(isLoading: true);
    try {
      final results = await _service.getWallpapers(
        query: trimmed,
        sorting: 'relevance',
        page: 1,
      );
      state = WallpaperListState(
        wallpapers: results,
        isLoading: false,
        currentPage: 1,
        hasMore: results.length >= AppConstants.pageSize,
      );
    } catch (e) {
      state = WallpaperListState(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || _currentQuery.isEmpty) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final more = await _service.getWallpapers(
        query: _currentQuery,
        sorting: 'relevance',
        page: nextPage,
      );
      state = state.copyWith(
        wallpapers: [...state.wallpapers, ...more],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: more.length >= AppConstants.pageSize,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, WallpaperListState>(
  (ref) => SearchNotifier(ref.read(waifuFeedServiceProvider)),
);
