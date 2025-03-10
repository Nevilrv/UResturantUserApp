import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';

class CommonConfig {
  Future<String?> loadImage(String storageName, String imageName, String extension) async {
    try {
      String fileName = '$imageName.$extension';
      final ref = FirebaseStorage.instance.ref().child('$storageName/$fileName');
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      log('Error loading image: $e');
    }
    return null;
  }
}
