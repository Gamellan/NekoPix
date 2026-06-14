import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/wallpaper_model.dart';

const _kFavoritesKey = 'waifu_pix_favorites_v1';

/// Manages the favorites list, persisted to SharedPreferences.
class FavoritesNotifier extends StateNotifier<List<WallpaperModel>> {
  FavoritesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = prefs.getStringList(_kFavoritesKey) ?? [];
      state = jsonList
          .map((s) =>
              WallpaperModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      state = [];
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _kFavoritesKey,
        state.map((w) => jsonEncode(w.toJson())).toList(),
      );
    } catch (_) {}
  }

  void toggle(WallpaperModel wallpaper) {
    if (state.any((w) => w.id == wallpaper.id)) {
      state = state.where((w) => w.id != wallpaper.id).toList();
    } else {
      state = [wallpaper, ...state]; // newest first
    }
    _persist();
  }

  bool isFavorite(String id) => state.any((w) => w.id == id);

  void remove(String id) {
    state = state.where((w) => w.id != id).toList();
    _persist();
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<WallpaperModel>>(
  (_) => FavoritesNotifier(),
);
