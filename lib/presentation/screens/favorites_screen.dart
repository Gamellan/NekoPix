import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../providers/favorites_provider.dart';
import '../widgets/wallpaper_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: _GradientTitle(
          title: context.l10n.appName,
          badge: context.l10n.favoritesBadge,
          badgeWithCount: context.l10n.favoritesBadgeCount(favorites.length),
          badgeCount: favorites.length,
        ),
      ),
      body: favorites.isEmpty
          ? _EmptyFavorites(
              title: context.l10n.noFavoritesYet,
              subtitle: context.l10n.favoritesEmptySubtitle,
            )
          : MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (_, i) =>
                  WallpaperCard(wallpaper: favorites[i], index: i),
            ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _GradientTitle extends StatelessWidget {
  final String title;
  final String badge;
  final String badgeWithCount;
  final int badgeCount;

  const _GradientTitle(
      {required this.title,
      required this.badge,
      required this.badgeWithCount,
      required this.badgeCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShaderMask(
          shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
          child: Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 26)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badgeCount > 0 ? badgeWithCount : badge,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyFavorites({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: const Icon(Icons.favorite_outline,
                size: 80, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
