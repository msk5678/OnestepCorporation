import 'dart:io';

import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompress {
  static Future<Uint8List> assetCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 30,
    );

    return result;
  }
}
