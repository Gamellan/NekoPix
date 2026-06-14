# NekoPix - Checklist de configuracion para produccion

Este documento resume TODO lo que debes cambiar/verificar antes de publicar NekoPix.

## 1) Identidad de app

Estado actual:
- Nombre app: NekoPix
- Package/Bundle ID Android: com.yourname.nekopix

Que debes ajustar:
- Reemplazar `yourname` por tu dominio invertido real.
- Ejemplo: `com.tunombre.nekopix` o `com.tumarca.nekopix`.

Archivos a revisar:
- android/app/build.gradle.kts
  - namespace
  - defaultConfig.applicationId
- android/app/src/main/kotlin/com/yourname/nekopix/MainActivity.kt
  - package
- Estructura de carpetas Kotlin debe coincidir con el package.

## 2) AdMob (imprescindible)

Actualmente hay IDs hardcodeados (heredados del proyecto base). Debes usar tus propios IDs.

Archivos y valores actuales:
- lib/core/constants/app_constants.dart
  - admobAppId
  - bannerAdUnitId
  - interstitialAdUnitId
- android/app/src/main/AndroidManifest.xml
  - meta-data com.google.android.gms.ads.APPLICATION_ID

Cambios requeridos:
1. Crear app Android en AdMob con el package final (el mismo que uses en Gradle).
2. Crear unidades de anuncio:
   - Banner
   - Interstitial
3. Reemplazar TODOS los IDs en los archivos anteriores.
4. Confirmar que `admobAppId` en Dart y el `APPLICATION_ID` del Manifest sean el mismo App ID.

Recomendado:
- Para desarrollo, usar IDs de prueba de Google.
- Para release, usar solo IDs reales de tu cuenta.

## 3) Firma y release Android

Estado actual:
- Proyecto preparado para firmar con `android/key.properties`.

Que debes hacer:
1. Crear keystore de release.
2. Crear `android/key.properties` (no subirlo al repo).
3. Completar:
   - storePassword
   - keyPassword
   - keyAlias
   - storeFile
4. Generar build release firmado:
   - flutter build appbundle --release

Nota:
- El proyecto ya cae a debug key si no encuentra key.properties, pero eso NO sirve para publicar.

## 4) Icono y branding

Estado actual:
- Icono configurado en pubspec con `flutter_launcher_icons`.
- Adaptive icon background sigue con color heredado (#EAD1F6).

Si quieres coherencia con NekoPix (mint):
- Cambiar `adaptive_icon_background` a un tono mint (ej: #A8E6CF)
- Regenerar iconos:
  - dart run flutter_launcher_icons

## 5) Politicas y cumplimiento

Por el tipo de app (wallpapers + ads + guardado/compartido):
- Politica de privacidad publicada y enlazada en Play Console.
- Declarar uso de permisos de medios/almacenamiento.
- Revisar cumplimiento de anuncios y contenido (AdMob + Play Policy).
- Si usas atribuciones de artistas, mantener visible el credito (ya implementado).

## 6) Backend/API

Estado actual:
- API: https://nekos.best/api/v2
- Endpoints por categoria:
  - /neko?amount=20
  - /kitsune?amount=20
  - /waifu?amount=20

Verificar antes de publicar:
- Rate limits
- Disponibilidad del servicio
- Estrategia de fallback si falla la API

## 7) QA final recomendado

Antes de subir a Play:
1. flutter pub get
2. flutter analyze
3. flutter test
4. Probar en dispositivo real:
   - Carga de imagenes por categoria
   - Credito de artista y link externo
   - Guardar en galeria
   - Aplicar wallpaper (home/lock/both)
   - Banner e interstitial
5. Build release:
   - flutter build appbundle --release

## 8) Opcionales utiles

- Mover IDs sensibles a `--dart-define` o flavors (dev/prod).
- Crear archivo `docs/release-notes.md` para controlar cambios por version.
- Configurar CI para analyze + test + build.
