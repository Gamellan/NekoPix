import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
  ];

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(localizations != null, 'No AppLocalizations found in context');
    return localizations!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get _lang {
    if (_localizedValues.containsKey(locale.languageCode)) {
      return locale.languageCode;
    }
    return 'en';
  }

  String _t(String key) {
    return _localizedValues[_lang]![key] ?? _localizedValues['en']![key] ?? key;
  }

  String get appName => _t('appName');
  String get navHome => _t('navHome');
  String get navSearch => _t('navSearch');
  String get navFavorites => _t('navFavorites');

  String get sortHot => _t('sortHot');
  String get sortToplist => _t('sortToplist');
  String get sortDateAdded => _t('sortDateAdded');
  String get sortRandom => _t('sortRandom');

  String labelForSorting(String key) {
    switch (key) {
      case 'neko':
        return 'Neko';
      case 'kitsune':
        return 'Kitsune';
      case 'waifu':
        return 'Waifu';
      default:
        return key;
    }
  }

  String get retry => _t('retry');
  String get searchHint => _t('searchHint');
  String get popularSearches => _t('popularSearches');
  String noResultsFor(String query) => _t('noResultsFor').replaceAll('{query}', query);

  String get favoritesBadge => _t('favoritesBadge');
  String favoritesBadgeCount(int count) =>
      _t('favoritesBadgeCount').replaceAll('{count}', count.toString());
  String get noFavoritesYet => _t('noFavoritesYet');
  String get favoritesEmptySubtitle => _t('favoritesEmptySubtitle');

  String get unknown => _t('unknown');
  String get source => _t('source');
  String get favoriteAction => _t('favoriteAction');
  String get saveAction => _t('saveAction');
  String get shareAction => _t('shareAction');
  String get processing => _t('processing');

  String get setWallpaperTitle => _t('setWallpaperTitle');
  String get homeScreen => _t('homeScreen');
  String get lockScreen => _t('lockScreen');
  String get bothScreens => _t('bothScreens');
  String get applyAction => _t('applyAction');

  String get wallpaperSetSuccess => _t('wallpaperSetSuccess');
  String wallpaperSetError(String message) =>
      _t('wallpaperSetError').replaceAll('{message}', message);
  String get galleryPermissionRequired => _t('galleryPermissionRequired');
  String get gallerySavedSuccess => _t('gallerySavedSuccess');
  String gallerySaveError(String message) =>
      _t('gallerySaveError').replaceAll('{message}', message);

  String shareMessage(String url) => _t('shareMessage').replaceAll('{url}', url);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'appName': 'NekoPix',
    'navHome': 'Home',
    'navSearch': 'Search',
    'navFavorites': 'Favorites',
    'sortHot': 'Trending',
    'sortToplist': 'Popular',
    'sortDateAdded': 'New',
    'sortRandom': 'Random',
    'retry': 'Retry',
    'searchHint': 'Search by category or artist...',
    'popularSearches': 'Popular searches',
    'noResultsFor': 'No results for "{query}"',
    'favoritesBadge': 'Favorites',
    'favoritesBadgeCount': 'Favorites ({count})',
    'noFavoritesYet': 'No favorites yet',
    'favoritesEmptySubtitle': 'Tap * on any wallpaper\nto save it here',
    'unknown': 'Unknown',
    'source': 'Source',
    'favoriteAction': 'Favorite',
    'saveAction': 'Save',
    'shareAction': 'Share',
    'processing': 'Processing...',
    'setWallpaperTitle': 'Set wallpaper',
    'homeScreen': 'Home screen',
    'lockScreen': 'Lock screen',
    'bothScreens': 'Both screens',
    'applyAction': 'Apply',
    'wallpaperSetSuccess': 'Wallpaper set successfully',
    'wallpaperSetError': 'Error setting wallpaper: {message}',
    'galleryPermissionRequired': 'Gallery permission is required',
    'gallerySavedSuccess': 'Saved to your gallery',
    'gallerySaveError': 'Error saving image: {message}',
    'shareMessage': 'Check out this wallpaper!\n{url}\n\nShared from NekoPix',
  },
  'es': {
    'appName': 'NekoPix',
    'navHome': 'Inicio',
    'navSearch': 'Buscar',
    'navFavorites': 'Favoritos',
    'sortHot': 'Tendencia',
    'sortToplist': 'Popular',
    'sortDateAdded': 'Nuevo',
    'sortRandom': 'Aleatorio',
    'retry': 'Reintentar',
    'searchHint': 'Buscar: rem, miku, zero two...',
    'popularSearches': 'Busquedas populares',
    'noResultsFor': 'Sin resultados para "{query}"',
    'favoritesBadge': 'Favoritos',
    'favoritesBadgeCount': 'Favoritos ({count})',
    'noFavoritesYet': 'Sin favoritos aun',
    'favoritesEmptySubtitle': 'Toca * en cualquier wallpaper\npara guardarlo aqui',
    'unknown': 'Desconocido',
    'source': 'Fuente',
    'favoriteAction': 'Favorito',
    'saveAction': 'Guardar',
    'shareAction': 'Compartir',
    'processing': 'Procesando...',
    'setWallpaperTitle': 'Establecer fondo de pantalla',
    'homeScreen': 'Pantalla de inicio',
    'lockScreen': 'Pantalla de bloqueo',
    'bothScreens': 'Ambas pantallas',
    'applyAction': 'Aplicar',
    'wallpaperSetSuccess': 'Fondo de pantalla establecido',
    'wallpaperSetError': 'Error al establecer: {message}',
    'galleryPermissionRequired': 'Se necesita permiso para guardar en la galeria',
    'gallerySavedSuccess': 'Guardado en tu galeria',
    'gallerySaveError': 'Error al guardar: {message}',
    'shareMessage': 'Mira este wallpaper!\n{url}\n\nCompartido desde NekoPix',
  },
  'pt': {
    'appName': 'NekoPix',
    'navHome': 'Inicio',
    'navSearch': 'Buscar',
    'navFavorites': 'Favoritos',
    'sortHot': 'Em alta',
    'sortToplist': 'Popular',
    'sortDateAdded': 'Novo',
    'sortRandom': 'Aleatorio',
    'retry': 'Tentar novamente',
    'searchHint': 'Buscar: rem, miku, zero two...',
    'popularSearches': 'Buscas populares',
    'noResultsFor': 'Sem resultados para "{query}"',
    'favoritesBadge': 'Favoritos',
    'favoritesBadgeCount': 'Favoritos ({count})',
    'noFavoritesYet': 'Ainda sem favoritos',
    'favoritesEmptySubtitle': 'Toque * em qualquer wallpaper\npara salvar aqui',
    'unknown': 'Desconhecido',
    'source': 'Fonte',
    'favoriteAction': 'Favorito',
    'saveAction': 'Salvar',
    'shareAction': 'Compartilhar',
    'processing': 'Processando...',
    'setWallpaperTitle': 'Definir papel de parede',
    'homeScreen': 'Tela inicial',
    'lockScreen': 'Tela de bloqueio',
    'bothScreens': 'Ambas as telas',
    'applyAction': 'Aplicar',
    'wallpaperSetSuccess': 'Papel de parede aplicado com sucesso',
    'wallpaperSetError': 'Erro ao aplicar papel de parede: {message}',
    'galleryPermissionRequired': 'Permissao da galeria e necessaria',
    'gallerySavedSuccess': 'Salvo na galeria',
    'gallerySaveError': 'Erro ao salvar imagem: {message}',
    'shareMessage': 'Olhe este wallpaper!\n{url}\n\nCompartilhado via NekoPix',
  },
  'fr': {
    'appName': 'NekoPix',
    'navHome': 'Accueil',
    'navSearch': 'Recherche',
    'navFavorites': 'Favoris',
    'sortHot': 'Tendance',
    'sortToplist': 'Populaire',
    'sortDateAdded': 'Nouveau',
    'sortRandom': 'Aleatoire',
    'retry': 'Reessayer',
    'searchHint': 'Rechercher : rem, miku, zero two...',
    'popularSearches': 'Recherches populaires',
    'noResultsFor': 'Aucun resultat pour "{query}"',
    'favoritesBadge': 'Favoris',
    'favoritesBadgeCount': 'Favoris ({count})',
    'noFavoritesYet': 'Aucun favori pour le moment',
    'favoritesEmptySubtitle': 'Touchez * sur un wallpaper\npour le sauvegarder ici',
    'unknown': 'Inconnu',
    'source': 'Source',
    'favoriteAction': 'Favori',
    'saveAction': 'Enregistrer',
    'shareAction': 'Partager',
    'processing': 'Traitement...',
    'setWallpaperTitle': 'Definir le fond d ecran',
    'homeScreen': 'Ecran d accueil',
    'lockScreen': 'Ecran de verrouillage',
    'bothScreens': 'Les deux ecrans',
    'applyAction': 'Appliquer',
    'wallpaperSetSuccess': 'Fond d ecran defini avec succes',
    'wallpaperSetError': 'Erreur lors de l application : {message}',
    'galleryPermissionRequired': 'Permission de la galerie requise',
    'gallerySavedSuccess': 'Enregistre dans la galerie',
    'gallerySaveError': 'Erreur lors de l enregistrement : {message}',
    'shareMessage': 'Regarde ce wallpaper !\n{url}\n\nPartage depuis NekoPix',
  },
  'de': {
    'appName': 'NekoPix',
    'navHome': 'Start',
    'navSearch': 'Suche',
    'navFavorites': 'Favoriten',
    'sortHot': 'Trend',
    'sortToplist': 'Beliebt',
    'sortDateAdded': 'Neu',
    'sortRandom': 'Zufallig',
    'retry': 'Erneut versuchen',
    'searchHint': 'Suchen: rem, miku, zero two...',
    'popularSearches': 'Beliebte Suchen',
    'noResultsFor': 'Keine Ergebnisse fur "{query}"',
    'favoritesBadge': 'Favoriten',
    'favoritesBadgeCount': 'Favoriten ({count})',
    'noFavoritesYet': 'Noch keine Favoriten',
    'favoritesEmptySubtitle': 'Tippe auf * bei einem Wallpaper\num es hier zu speichern',
    'unknown': 'Unbekannt',
    'source': 'Quelle',
    'favoriteAction': 'Favorit',
    'saveAction': 'Speichern',
    'shareAction': 'Teilen',
    'processing': 'Wird verarbeitet...',
    'setWallpaperTitle': 'Wallpaper festlegen',
    'homeScreen': 'Startbildschirm',
    'lockScreen': 'Sperrbildschirm',
    'bothScreens': 'Beide Bildschirme',
    'applyAction': 'Anwenden',
    'wallpaperSetSuccess': 'Wallpaper erfolgreich gesetzt',
    'wallpaperSetError': 'Fehler beim Setzen: {message}',
    'galleryPermissionRequired': 'Galerie-Berechtigung ist erforderlich',
    'gallerySavedSuccess': 'In der Galerie gespeichert',
    'gallerySaveError': 'Fehler beim Speichern: {message}',
    'shareMessage': 'Schau dir dieses Wallpaper an!\n{url}\n\nGeteilt mit NekoPix',
  },
  'it': {
    'appName': 'NekoPix',
    'navHome': 'Home',
    'navSearch': 'Cerca',
    'navFavorites': 'Preferiti',
    'sortHot': 'Di tendenza',
    'sortToplist': 'Popolare',
    'sortDateAdded': 'Nuovo',
    'sortRandom': 'Casuale',
    'retry': 'Riprova',
    'searchHint': 'Cerca: rem, miku, zero two...',
    'popularSearches': 'Ricerche popolari',
    'noResultsFor': 'Nessun risultato per "{query}"',
    'favoritesBadge': 'Preferiti',
    'favoritesBadgeCount': 'Preferiti ({count})',
    'noFavoritesYet': 'Nessun preferito',
    'favoritesEmptySubtitle': 'Tocca * su qualsiasi wallpaper\nper salvarlo qui',
    'unknown': 'Sconosciuto',
    'source': 'Fonte',
    'favoriteAction': 'Preferito',
    'saveAction': 'Salva',
    'shareAction': 'Condividi',
    'processing': 'Elaborazione...',
    'setWallpaperTitle': 'Imposta sfondo',
    'homeScreen': 'Schermata home',
    'lockScreen': 'Schermata di blocco',
    'bothScreens': 'Entrambe le schermate',
    'applyAction': 'Applica',
    'wallpaperSetSuccess': 'Sfondo impostato con successo',
    'wallpaperSetError': 'Errore durante l impostazione: {message}',
    'galleryPermissionRequired': 'Permesso galleria richiesto',
    'gallerySavedSuccess': 'Salvato nella galleria',
    'gallerySaveError': 'Errore durante il salvataggio: {message}',
    'shareMessage': 'Guarda questo wallpaper!\n{url}\n\nCondiviso da NekoPix',
  },
  'ja': {
    'appName': 'NekoPix',
    'navHome': 'ãƒ›ãƒ¼ãƒ ',
    'navSearch': 'æ¤œç´¢',
    'navFavorites': 'ãŠæ°—ã«å…¥ã‚Š',
    'sortHot': 'ãƒˆãƒ¬ãƒ³ãƒ‰',
    'sortToplist': 'äººæ°—',
    'sortDateAdded': 'æ–°ç€',
    'sortRandom': 'ãƒ©ãƒ³ãƒ€ãƒ ',
    'retry': 'å†è©¦è¡Œ',
    'searchHint': 'æ¤œç´¢: rem, miku, zero two...',
    'popularSearches': 'äººæ°—ã®æ¤œç´¢',
    'noResultsFor': '"{query}" ã®çµæžœãŒã‚ã‚Šã¾ã›ã‚“',
    'favoritesBadge': 'ãŠæ°—ã«å…¥ã‚Š',
    'favoritesBadgeCount': 'ãŠæ°—ã«å…¥ã‚Š ({count})',
    'noFavoritesYet': 'ãŠæ°—ã«å…¥ã‚Šã¯ã¾ã ã‚ã‚Šã¾ã›ã‚“',
    'favoritesEmptySubtitle': 'Tap * on any wallpaper\nto save it here',
    'unknown': 'ä¸æ˜Ž',
    'source': 'ã‚½ãƒ¼ã‚¹',
    'favoriteAction': 'ãŠæ°—ã«å…¥ã‚Š',
    'saveAction': 'ä¿å­˜',
    'shareAction': 'å…±æœ‰',
    'processing': 'å‡¦ç†ä¸­...',
    'setWallpaperTitle': 'å£ç´™ã‚’è¨­å®š',
    'homeScreen': 'ãƒ›ãƒ¼ãƒ ç”»é¢',
    'lockScreen': 'ãƒ­ãƒƒã‚¯ç”»é¢',
    'bothScreens': 'ä¸¡æ–¹ã®ç”»é¢',
    'applyAction': 'é©ç”¨',
    'wallpaperSetSuccess': 'å£ç´™ã‚’è¨­å®šã—ã¾ã—ãŸ',
    'wallpaperSetError': 'è¨­å®šã‚¨ãƒ©ãƒ¼: {message}',
    'galleryPermissionRequired': 'ã‚®ãƒ£ãƒ©ãƒªãƒ¼æ¨©é™ãŒå¿…è¦ã§ã™',
    'gallerySavedSuccess': 'ã‚®ãƒ£ãƒ©ãƒªãƒ¼ã«ä¿å­˜ã—ã¾ã—ãŸ',
    'gallerySaveError': 'ä¿å­˜ã‚¨ãƒ©ãƒ¼: {message}',
    'shareMessage': 'ã“ã®å£ç´™ã‚’è¦‹ã¦ãã ã•ã„!\n{url}\n\nNekoPix ã‹ã‚‰å…±æœ‰',
  },
  'ko': {
    'appName': 'NekoPix',
    'navHome': 'í™ˆ',
    'navSearch': 'ê²€ìƒ‰',
    'navFavorites': 'ì¦ê²¨ì°¾ê¸°',
    'sortHot': 'íŠ¸ë Œë“œ',
    'sortToplist': 'ì¸ê¸°',
    'sortDateAdded': 'ì‹ ê·œ',
    'sortRandom': 'ëžœë¤',
    'retry': 'ë‹¤ì‹œ ì‹œë„',
    'searchHint': 'ê²€ìƒ‰: rem, miku, zero two...',
    'popularSearches': 'ì¸ê¸° ê²€ìƒ‰ì–´',
    'noResultsFor': '"{query}" ì— ëŒ€í•œ ê²°ê³¼ê°€ ì—†ìŠµë‹ˆë‹¤',
    'favoritesBadge': 'ì¦ê²¨ì°¾ê¸°',
    'favoritesBadgeCount': 'ì¦ê²¨ì°¾ê¸° ({count})',
    'noFavoritesYet': 'ì•„ì§ ì¦ê²¨ì°¾ê¸°ê°€ ì—†ìŠµë‹ˆë‹¤',
    'favoritesEmptySubtitle': 'Tap * on any wallpaper\nto save it here',
    'unknown': 'ì•Œ ìˆ˜ ì—†ìŒ',
    'source': 'ì¶œì²˜',
    'favoriteAction': 'ì¦ê²¨ì°¾ê¸°',
    'saveAction': 'ì €ìž¥',
    'shareAction': 'ê³µìœ ',
    'processing': 'ì²˜ë¦¬ ì¤‘...',
    'setWallpaperTitle': 'ë°°ê²½í™”ë©´ ì„¤ì •',
    'homeScreen': 'í™ˆ í™”ë©´',
    'lockScreen': 'ìž ê¸ˆ í™”ë©´',
    'bothScreens': 'ë‘˜ ë‹¤',
    'applyAction': 'ì ìš©',
    'wallpaperSetSuccess': 'ë°°ê²½í™”ë©´ì´ ì„¤ì •ë˜ì—ˆìŠµë‹ˆë‹¤',
    'wallpaperSetError': 'ì„¤ì • ì˜¤ë¥˜: {message}',
    'galleryPermissionRequired': 'ê°¤ëŸ¬ë¦¬ ê¶Œí•œì´ í•„ìš”í•©ë‹ˆë‹¤',
    'gallerySavedSuccess': 'ê°¤ëŸ¬ë¦¬ì— ì €ìž¥ë¨',
    'gallerySaveError': 'ì €ìž¥ ì˜¤ë¥˜: {message}',
    'shareMessage': 'ì´ ë°°ê²½í™”ë©´ì„ í™•ì¸í•´ë³´ì„¸ìš”!\n{url}\n\nNekoPixì—ì„œ ê³µìœ ë¨',
  },
};


