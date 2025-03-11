import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> downloadImageToHiddenTemp(String imageUrl) async {
  try {
    log('imageUrl::::::::::::::::${imageUrl}');
    // Get temporary directory
    Directory tempDir = await getTemporaryDirectory();

    log('tempDir::::::::::::::::${tempDir.path}');
    // Create a hidden folder inside temp directory
    Directory hiddenDir = Directory('${tempDir.path}/.hidden_images');
    if (!await hiddenDir.exists()) {
      await hiddenDir.create(recursive: true);
    }

    // Extract file name without subdirectories
    String fileName = Uri.parse(imageUrl).pathSegments.last.split('?').first;

    // Create full file path
    File file = File('${hiddenDir.path}/$fileName');

    // Ensure the parent directory exists
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    // Download the image
    var response = await http.get(Uri.parse(imageUrl));
    log('response.statusCode::::::::::::::::${response.statusCode}');
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      return file.path; // Return the file path
    } else {
      return "";
    }
  } catch (e) {
    print("Error: $e");
    return ""; // Return empty string on error
  }
}
