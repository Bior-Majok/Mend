import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'firebase_service.dart';

class StorageService {
  final FirebaseStorage? _storage =
      FirebaseService.isInitialized ? FirebaseStorage.instance : null;

  Future<String?> uploadIncidentImage(XFile imageFile) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      final String filename = 'incident_${const Uuid().v4()}.jpg';
      final storage = _storage;

      if (FirebaseService.isInitialized && storage != null) {
        final ref = storage.ref().child('incidents').child(filename);
        final metadata = SettableMetadata(contentType: 'image/jpeg');
        final uploadTask = await ref.putData(bytes, metadata);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        return downloadUrl;
      } else {
        // Fallback to base64 string
        final base64String = base64Encode(bytes);
        return 'data:image/jpeg;base64,$base64String';
      }
    } catch (e) {
      debugPrint('Error uploading incident image: $e');
      try {
        final Uint8List bytes = await imageFile.readAsBytes();
        return 'data:image/jpeg;base64,${base64Encode(bytes)}';
      } catch (err) {
        return null;
      }
    }
  }
}
