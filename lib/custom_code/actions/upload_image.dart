// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:image_picker/image_picker.dart';

Future<FFUploadedFile> uploadImage() async {
  // Add your function code here!

  const allowedExtensions = <String>{
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'bmp',
    'heic',
    'heif',
    'tif',
    'tiff',
    'jfif'
  };

  final picker = ImagePicker();

  XFile? picked;
  try {
    picked = await picker.pickImage(source: ImageSource.gallery);
  } catch (e) {
    // Platform threw (permissions denied, etc). Return an empty file so
    // the calling action flow can check bytes.isEmpty and branch on it.
    return FFUploadedFile(name: '', bytes: Uint8List(0));
  }

  // User backed out of the picker without choosing anything.
  if (picked == null) {
    return FFUploadedFile(name: '', bytes: Uint8List(0));
  }

  final name = picked.name.toLowerCase();
  final dot = name.lastIndexOf('.');
  final ext = dot == -1 ? '' : name.substring(dot + 1);

  if (!allowedExtensions.contains(ext)) {
    // Picked file isn't a recognized image format — reject it the same way.
    return FFUploadedFile(name: '', bytes: Uint8List(0));
  }

  final bytes = await picked.readAsBytes();

  return FFUploadedFile(
    name: picked.name,
    bytes: bytes,
  );
}
