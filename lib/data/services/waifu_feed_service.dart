import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../models/wallpaper_model.dart';

/// Fetches wallpapers from nekos.best API v2.
class WaifuFeedService {
  final Dio _dio;
  final Map<String, List<WallpaperModel>> _pageCache = {};

  WaifuFeedService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.nekosBestBaseUrl,
            connectTimeout: const Duration(seconds: 12),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'User-Agent': 'NekoPix Android/1.0',
              'Accept': 'application/json',
            },
          ),
        );

  Future<List<WallpaperModel>> getWallpapers({
    String sorting = 'hot',
    String? query,
    int page = 1,
  }) async {
    final normalizedQuery = query?.trim() ?? '';
    final category = _normalizeCategory(sorting, normalizedQuery);
    final cacheKey = '$category|${normalizedQuery.toLowerCase()}|$page';
    final cached = _pageCache[cacheKey];
    if (cached != null) return cached;

    final result = await _fetchNekosBest(
      category: category,
      query: normalizedQuery,
      page: page,
    );
    final merged = <WallpaperModel>[];
    final ids = <String>{};

    for (final item in result) {
      final key = item.path;
      if (!ids.contains(key)) {
        ids.add(key);
        merged.add(item);
      }
    }

    _pageCache[cacheKey] = List<WallpaperModel>.unmodifiable(merged);
    return _pageCache[cacheKey]!;
  }

  String _normalizeCategory(String sorting, String query) {
    final normalizedSorting = sorting.toLowerCase().trim();
    if (normalizedSorting == 'neko' ||
        normalizedSorting == 'kitsune' ||
        normalizedSorting == 'waifu') {
      return normalizedSorting;
    }

    final normalizedQuery = query.toLowerCase();
    if (normalizedQuery.contains('kitsune')) return 'kitsune';
    if (normalizedQuery.contains('waifu')) return 'waifu';
    return 'neko';
  }

  Future<List<WallpaperModel>> _fetchNekosBest({
    required String category,
    required String query,
    required int page,
  }) async {
    try {
      final response = await _dio.get(
        '/$category',
        queryParameters: {
          'amount': AppConstants.pageSize,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final results =
          (data['results'] as List?)?.cast<Map<String, dynamic>>() ?? const [];

      final mapped = results
          .asMap()
          .entries
          .map((entry) => _mapNekosBest(entry.value, category, page, entry.key))
          .where((w) => w.path.isNotEmpty)
          .toList();

      if (query.isEmpty) return mapped;

      final q = query.toLowerCase();
      return mapped.where((w) {
        return w.artistName.toLowerCase().contains(q) ||
            w.artistProfile.toLowerCase().contains(q) ||
            w.tags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    } on DioException {
      return [];
    }
  }

  WallpaperModel _mapNekosBest(
    Map<String, dynamic> json,
    String category,
    int page,
    int index,
  ) {
    final url = (json['url'] ?? '').toString();
    final artistName = (json['artist_name'] ?? '').toString();
    final artistHref = (json['artist_href'] ?? '').toString();
    final id = '${category}_${page}_${index}_${url.hashCode}';

    return WallpaperModel(
      id: id,
      path: url,
      thumbLarge: url,
      thumbSmall: url,
      width: 0,
      height: 0,
      resolution: '',
      views: (json['views'] as num?)?.toInt() ?? 0,
      favorites: 0,
      colors: const [],
      fileType: 'image/jpeg',
      createdAt: (json['created_at'] ?? '').toString(),
      sourcePlatform: 'nekos.best',
      sourceUrl: url,
      artistName: artistName,
      artistProfile: artistHref,
      copyrightNotice: 'Source: nekos.best',
      tags: [category],
    );
  }
}
