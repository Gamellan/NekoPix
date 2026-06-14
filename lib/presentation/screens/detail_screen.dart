import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/wallpaper_model.dart';
import '../providers/ad_manager.dart';
import '../providers/favorites_provider.dart';

/// Full-screen wallpaper viewer with:
///  • Pinch-to-zoom (InteractiveViewer)
///  • Favorite toggle
///  • Set as wallpaper (Home / Lock / Both)
///  • Download to gallery
///  • Share
///  • AdMob interstitial on wallpaper set
class DetailScreen extends ConsumerStatefulWidget {
  final WallpaperModel wallpaper;
  final String heroTag;

  const DetailScreen({
    super.key,
    required this.wallpaper,
    required this.heroTag,
  });

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final WallpaperManagerFlutter _wallpaperManager = WallpaperManagerFlutter();
  bool _showControls = true;
  bool _isBusy = false;
  double _downloadProgress = 0;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final isFav = ref.watch(
      favoritesProvider.select((list) => list.any((w) => w.id == widget.wallpaper.id)),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Full-resolution image with pinch-to-zoom ──────────────────
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(
                child: Hero(
                  tag: widget.heroTag,
                  child: CachedNetworkImage(
                    imageUrl: widget.wallpaper.path,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    errorWidget: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image_outlined,
                          size: 64, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            // ── Animated controls overlay ─────────────────────────────────
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 220),
              child: IgnorePointer(
                ignoring: !_showControls,
                child: Stack(
                  children: [
                    // Top gradient
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: padding.top + 80,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    // Back button
                    Positioned(
                      top: padding.top + 8,
                      left: 8,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.black38),
                      ),
                    ),
                    // Bottom gradient + actions
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            20, 40, 20, padding.bottom + 20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black87,
                              Colors.black45,
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Meta info row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _MetaChip(
                                  icon: Icons.photo_size_select_actual_outlined,
                                  label: widget.wallpaper.resolution,
                                ),
                                const SizedBox(width: 14),
                                _MetaChip(
                                  icon: Icons.remove_red_eye_outlined,
                                  label: _fmt(widget.wallpaper.views),
                                ),
                                const SizedBox(width: 14),
                                _MetaChip(
                                  icon: Icons.favorite,
                                  label: _fmt(widget.wallpaper.favorites),
                                  iconColor: AppTheme.secondaryColor,
                                ),
                              ],
                            ),
                            if (widget.wallpaper.artistName.isNotEmpty ||
                                widget.wallpaper.sourcePlatform.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: GestureDetector(
                                  onTap: widget.wallpaper.artistProfile.isEmpty
                                      ? null
                                      : () => launchUrlString(
                                            widget.wallpaper.artistProfile,
                                            mode: LaunchMode.externalApplication,
                                          ),
                                  child: Text(
                                    '© ${widget.wallpaper.artistName.isNotEmpty ? widget.wallpaper.artistName : context.l10n.unknown} · ${widget.wallpaper.sourcePlatform.isNotEmpty ? widget.wallpaper.sourcePlatform : context.l10n.source}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: widget.wallpaper.artistProfile.isEmpty
                                          ? Colors.white70
                                          : AppTheme.primaryColor,
                                      fontSize: 11,
                                      decoration: widget.wallpaper.artistProfile.isEmpty
                                          ? TextDecoration.none
                                          : TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Attribution: https://nekos.best/',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ActionButton(
                                  icon: isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav
                                      ? AppTheme.secondaryColor
                                      : Colors.white,
                                  label: context.l10n.favoriteAction,
                                  onTap: () => ref
                                      .read(favoritesProvider.notifier)
                                      .toggle(widget.wallpaper),
                                ),
                                _SetWallpaperButton(
                                  isBusy: _isBusy,
                                  onTap: () =>
                                      _showWallpaperSheet(context),
                                ),
                                _ActionButton(
                                  icon: Icons.download_outlined,
                                  color: Colors.white,
                                  label: context.l10n.saveAction,
                                  onTap: _download,
                                ),
                                _ActionButton(
                                  icon: Icons.ios_share_outlined,
                                  color: Colors.white,
                                  label: context.l10n.shareAction,
                                  onTap: _share,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Download progress overlay ─────────────────────────────────
            if (_isBusy)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        value: _downloadProgress > 0 ? _downloadProgress : null,
                        color: AppTheme.primaryColor,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _downloadProgress > 0
                            ? '${(_downloadProgress * 100).toInt()}%'
                            : context.l10n.processing,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Bottom sheet: choose wallpaper target ─────────────────────────────────
  void _showWallpaperSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                context.l10n.setWallpaperTitle,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            _SheetOption(
              icon: Icons.home_outlined,
              label: context.l10n.homeScreen,
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(WallpaperManagerFlutter.homeScreen);
              },
            ),
            _SheetOption(
              icon: Icons.lock_outline,
              label: context.l10n.lockScreen,
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(WallpaperManagerFlutter.lockScreen);
              },
            ),
            _SheetOption(
              icon: Icons.smartphone,
              label: context.l10n.bothScreens,
              onTap: () {
                Navigator.pop(context);
                _setWallpaper(WallpaperManagerFlutter.bothScreens);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ── Set wallpaper flow ────────────────────────────────────────────────────
  Future<void> _setWallpaper(int location) async {
    final l10n = context.l10n;
    setState(() {
      _isBusy = true;
      _downloadProgress = 0;
    });
    try {
      final filePath = await _ensureLocalFile();
      final ok = await _wallpaperManager.setWallpaper(File(filePath), location);
      if (!ok) {
        throw Exception('unknown');
      }

      // Notify ad manager → shows interstitial every N sets
      ref.read(adManagerProvider.notifier).onWallpaperSet();

      if (mounted) {
        setState(() => _isBusy = false);
        _snack('✓ ${l10n.wallpaperSetSuccess}', color: AppTheme.primaryColor);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isBusy = false);
        _snack(l10n.wallpaperSetError(e.toString()), color: Colors.red);
      }
    }
  }

  // ── Download to gallery flow ──────────────────────────────────────────────
  Future<void> _download() async {
    final l10n = context.l10n;
    // Request gallery access (gal handles the permission dialog internally)
    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final granted = await Gal.requestAccess();
      if (!granted) {
        _snack(l10n.galleryPermissionRequired);
        return;
      }
    }

    setState(() {
      _isBusy = true;
      _downloadProgress = 0;
    });
    try {
      final filePath = await _ensureLocalFile();
      await Gal.putImage(filePath, album: 'NekoPix');
      if (mounted) {
        setState(() => _isBusy = false);
        _snack('✓ ${l10n.gallerySavedSuccess}', color: AppTheme.primaryColor);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isBusy = false);
        _snack(l10n.gallerySaveError(e.toString()), color: Colors.red);
      }
    }
  }

  // ── Share ─────────────────────────────────────────────────────────────────
  void _share() {
    Share.share(context.l10n.shareMessage(widget.wallpaper.path));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Downloads the full-res image to the temp directory (or reuses if cached).
  Future<String> _ensureLocalFile() async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/nekopix_${widget.wallpaper.id}.jpg';
    final file = File(filePath);
    if (!file.existsSync()) {
      await Dio().download(
        widget.wallpaper.path,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );
    }
    return filePath;
  }

  void _snack(String msg, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _MetaChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: iconColor ?? Colors.white54),
        const SizedBox(width: 3),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

/// The primary "Apply" CTA button (gradient circle, larger than secondary actions).
class _SetWallpaperButton extends StatelessWidget {
  final bool isBusy;
  final VoidCallback onTap;

  const _SetWallpaperButton({required this.isBusy, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBusy ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.45),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.wallpaper, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.applyAction,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(label,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right,
          color: AppTheme.textSecondary, size: 20),
      onTap: onTap,
    );
  }
}
