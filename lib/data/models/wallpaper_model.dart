import 'dart:convert';

/// Represents a single wallpaper from the Wallhaven API.
class WallpaperModel {
  final String id;

  /// Full-resolution image URL.
  final String path;

  /// Large thumbnail URL (used in grid).
  final String thumbLarge;

  /// Small thumbnail URL.
  final String thumbSmall;

  final int width;
  final int height;
  final String resolution;
  final int views;
  final int favorites;
  final List<String> colors;
  final String fileType;
  final String createdAt;
  final String sourcePlatform;
  final String sourceUrl;
  final String artistName;
  final String artistProfile;
  final String copyrightNotice;
  final List<String> tags;

  const WallpaperModel({
    required this.id,
    required this.path,
    required this.thumbLarge,
    required this.thumbSmall,
    required this.width,
    required this.height,
    required this.resolution,
    required this.views,
    required this.favorites,
    required this.colors,
    required this.fileType,
    required this.createdAt,
    this.sourcePlatform = '',
    this.sourceUrl = '',
    this.artistName = '',
    this.artistProfile = '',
    this.copyrightNotice = '',
    this.tags = const [],
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    final thumbs = json['thumbs'] as Map<String, dynamic>? ?? {};
    return WallpaperModel(
      id: json['id']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      thumbLarge: thumbs['large']?.toString() ?? '',
      thumbSmall: thumbs['small']?.toString() ?? '',
      width: (json['dimension_x'] as num?)?.toInt() ?? 0,
      height: (json['dimension_y'] as num?)?.toInt() ?? 0,
      resolution: json['resolution']?.toString() ?? '',
      views: (json['views'] as num?)?.toInt() ?? 0,
      favorites: (json['favorites'] as num?)?.toInt() ?? 0,
      colors: (json['colors'] as List?)?.map((c) => c.toString()).toList() ?? [],
      fileType: json['file_type']?.toString() ?? 'image/jpeg',
      createdAt: json['created_at']?.toString() ?? '',
      sourcePlatform: json['source_platform']?.toString() ?? '',
      sourceUrl: json['source_url']?.toString() ?? '',
      artistName: json['artist_name']?.toString() ?? '',
      artistProfile: json['artist_profile']?.toString() ?? '',
      copyrightNotice: json['copyright_notice']?.toString() ?? '',
      tags: (json['tags'] as List?)?.map((c) => c.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'path': path,
        'thumbs': {'large': thumbLarge, 'small': thumbSmall},
        'dimension_x': width,
        'dimension_y': height,
        'resolution': resolution,
        'views': views,
        'favorites': favorites,
        'colors': colors,
        'file_type': fileType,
        'created_at': createdAt,
        'source_platform': sourcePlatform,
        'source_url': sourceUrl,
        'artist_name': artistName,
        'artist_profile': artistProfile,
        'copyright_notice': copyrightNotice,
        'tags': tags,
      };

  String toJsonString() => jsonEncode(toJson());

  static WallpaperModel fromJsonString(String s) =>
      WallpaperModel.fromJson(jsonDecode(s) as Map<String, dynamic>);

  double get aspectRatio => height > 0 ? width / height : 1.0;
  bool get isPortrait => height >= width;
}
