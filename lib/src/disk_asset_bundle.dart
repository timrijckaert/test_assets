import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:glob/glob.dart';

/// A simple implementation of [AssetBundle] that reads files from an asset dir.
///
/// This is meant to be similar to the default [rootBundle] for testing.
class DiskAssetBundle extends CachingAssetBundle {
  static const _assetManifestDotJson = 'AssetManifest.json';

  /// Creates a [DiskAssetBundle] by loading [globs] of assets under `assets/`.
  static Future<AssetBundle> loadGlob(Iterable<String> globs, {String from = 'assets'}) async {
    final cache = <String, ByteData>{};
    for (final pattern in globs) {
      final List<FileSystemEntity> fontList = await Glob(pattern).list(root: from).toList();
      for (final item in fontList) {
        if (item is File) {
          final path = item.path;
          final bytes = await item.readAsBytes() as Uint8List;
          cache[path] = ByteData.view(bytes.buffer);
          //print("loaded asset on path: $path");
        }
      }
    }
    final manifest = <String, List<String>>{};
    cache.forEach((key, _) {
      manifest[key] = [key];
    });

    cache[_assetManifestDotJson] = ByteData.view(
      Uint8List.fromList(jsonEncode(manifest).codeUnits).buffer,
    );

    return DiskAssetBundle._(cache);
  }

  final Map<String, ByteData> _cache;

  DiskAssetBundle._(this._cache);

  @override
  Future<ByteData> load(String key) async => _cache[key];
}
