/// App-wide constants: API endpoints, AdMob IDs, sorting options, popular tags.
class AppConstants {
  AppConstants._();

  // ── Content API ───────────────────────────────────────────────────────────
  static const String nekosBestBaseUrl = 'https://nekos.best/api/v2';

  // ── AdMob IDs ─────────────────────────────────────────────────────────────
    // AdMob production IDs
  static const String admobAppId =
      'ca-app-pub-6761615013970031~1035279446'; // App ID
  static const String bannerAdUnitId =
      'ca-app-pub-6761615013970031/9918600075'; // Banner
  static const String interstitialAdUnitId =
      'ca-app-pub-6761615013970031/8530626083'; // Interstitial

  /// Show an interstitial ad every N times the user sets a wallpaper.
  static const int interstitialFrequency = 3;

  /// Number of wallpapers loaded per request from nekos.best.
  static const int pageSize = 20;

  // ── Home categories ───────────────────────────────────────────────────────
  static const List<Map<String, String>> sortingOptions = [
    {'key': 'neko', 'label': 'Neko', 'icon': '🐱'},
    {'key': 'kitsune', 'label': 'Kitsune', 'icon': '🦊'},
    {'key': 'waifu', 'label': 'Waifu', 'icon': '💖'},
  ];

  // ── Popular search tags (shown as chips in Search screen) ─────────────────
  static const List<String> popularTags = [
    'neko',
    'kitsune',
    'waifu',
    'cat ears',
    'fox girl',
    'kawaii',
  ];
}
