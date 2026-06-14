import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/app_constants.dart';

/// Manages loading and showing interstitial ads.
/// An interstitial is shown every [AppConstants.interstitialFrequency] wallpaper sets.
class AdManager extends StateNotifier<int> {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  AdManager() : super(0) {
    _loadInterstitial();
  }

  Future<void> _loadInterstitial() async {
    if (_isLoading) return;
    _isLoading = true;
    await InterstitialAd.load(
      adUnitId: AppConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (_) {
          _isLoading = false;
        },
      ),
    );
  }

  /// Call this each time the user successfully sets a wallpaper.
  void onWallpaperSet() {
    state++;
    if (state % AppConstants.interstitialFrequency == 0) {
      _showInterstitial();
    }
  }

  void _showInterstitial() {
    if (_interstitialAd == null) {
      _loadInterstitial();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial(); // preload next
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }
}

final adManagerProvider =
    StateNotifierProvider<AdManager, int>((_) => AdManager());
