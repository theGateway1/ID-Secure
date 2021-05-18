import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAPI {
  static UploadTask uploadBytes(String destination, Uint8List bytes) {
    try {
      if (bytes == null) {
        print("null bytes");
        return null;
      }
      print("It came here");
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(bytes);
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.toString());
      return null;
    }
  }
}
