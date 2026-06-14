import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../providers/wallpaper_provider.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/shimmer_grid.dart';
import '../widgets/wallpaper_card.dart';

/// Home screen with category tabs: neko, kitsune, waifu.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: AppConstants.sortingOptions.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppTheme.primaryGradient.createShader(b),
                    child: const Text(
                      'NekoPix',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'HD',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // ── Tabs ─────────────────────────────────────────────────────────
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: AppConstants.sortingOptions
                  .map(
                    (opt) => Tab(
                      child: Row(
                        children: [
                          Text(opt['icon']!,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(context.l10n.labelForSorting(opt['key']!)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),

            const Divider(height: 1, thickness: 1, color: AppTheme.surfaceColor),

            // ── Tab content ───────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: AppConstants.sortingOptions
                    .map((opt) => _WallpaperFeed(sorting: opt['key']!))
                    .toList(),
              ),
            ),

            // ── AdMob banner ──────────────────────────────────────────────────
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }
}

// ── Per-tab paginated feed ────────────────────────────────────────────────────

class _WallpaperFeed extends ConsumerStatefulWidget {
  final String sorting;

  const _WallpaperFeed({required this.sorting});

  @override
  ConsumerState<_WallpaperFeed> createState() => _WallpaperFeedState();
}

class _WallpaperFeedState extends ConsumerState<_WallpaperFeed>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true; // keep state when switching tabs

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      ref.read(wallpaperListProvider(widget.sorting).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(wallpaperListProvider(widget.sorting));

    if (state.isLoading) return const ShimmerGrid();

    if (state.error != null && state.wallpapers.isEmpty) {
      return _ErrorView(
        message: state.error!,
        onRetry: () => ref
            .read(wallpaperListProvider(widget.sorting).notifier)
            .refresh(),
      );
    }

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      backgroundColor: AppTheme.cardColor,
      onRefresh: () =>
          ref.read(wallpaperListProvider(widget.sorting).notifier).refresh(),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(12),
        itemCount:
            state.wallpapers.length + (state.isLoadingMore ? 2 : 0),
        itemBuilder: (_, i) {
          if (i >= state.wallpapers.length) {
            // Loading skeleton cards at the bottom
            return Container(
              height: i.isEven ? 200 : 160,
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }
          return WallpaperCard(
              wallpaper: state.wallpapers[i], index: i);
        },
      ),
    );
  }
}

// ── Shared error view ─────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined,
                size: 64, color: AppTheme.textSecondary),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
