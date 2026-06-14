import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/wallpaper_model.dart';
import '../screens/detail_screen.dart';
import 'shimmer_grid.dart';

/// Single wallpaper card shown in the masonry grid.
/// Displays the large thumbnail with a bottom gradient overlay (favorites count + resolution).
class WallpaperCard extends StatelessWidget {
  final WallpaperModel wallpaper;
  final int index;

  const WallpaperCard({super.key, required this.wallpaper, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final heroTag = 'wallpaper_${wallpaper.id}_${identityHashCode(this)}';
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              DetailScreen(wallpaper: wallpaper, heroTag: heroTag),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 280),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // ── Thumbnail ─────────────────────────────────────────────
                  CachedNetworkImage(
                    imageUrl: wallpaper.thumbLarge,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const ShimmerPlaceholder(),
                    errorWidget: (_, __, ___) => Container(
                      height: 200,
                      color: AppTheme.cardColor,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  // ── Bottom info overlay ───────────────────────────────────
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.75),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite,
                              color: Color(0xFF6CC9A8), size: 12),
                          const SizedBox(width: 3),
                          Text(
                            _fmt(wallpaper.favorites),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (wallpaper.resolution.isNotEmpty)
                            Text(
                              wallpaper.resolution,
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 9),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (wallpaper.artistName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
              child: GestureDetector(
                onTap: wallpaper.artistProfile.isEmpty
                    ? null
                    : () => launchUrlString(
                          wallpaper.artistProfile,
                          mode: LaunchMode.externalApplication,
                        ),
                child: Text(
                  'Art: ${wallpaper.artistName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: wallpaper.artistProfile.isEmpty
                        ? AppTheme.textSecondary
                        : const Color(0xFF2E7D66),
                    decoration: wallpaper.artistProfile.isEmpty
                        ? TextDecoration.none
                        : TextDecoration.underline,
                  ),
                ),
              ),
            ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: (index % 12) * 40))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.04, end: 0, duration: 300.ms);
  }

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}
