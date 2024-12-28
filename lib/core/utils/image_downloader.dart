import 'dart:typed_data';

import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageDownloader {
  final SupabaseClient _supabaseClient;

  ImageDownloader(this._supabaseClient);

  Future<List<Uint8List>> downloadImages(List<ImageRecord> items) async {
    List<Uint8List> images = [];

    for (ImageRecord item in items) {
      final String fullPath = item.filePath.toString();
      final String formattedPath = fullPath.replaceFirst("images/", "");

      final imageBlob =
          await _supabaseClient.storage.from("images").download(formattedPath);
      images.add(imageBlob);
    }

    return images;
  }
}
