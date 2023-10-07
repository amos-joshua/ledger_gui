import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'alert.dart';

class SelectPreferencesFileDialog {
  final BuildContext context;
  SelectPreferencesFileDialog(this.context);

  Future<String?> show({String? initialDirectory}) async {
    final result = await FilePicker.platform.pickFiles(initialDirectory: initialDirectory);
    if (result == null) return null;
    if (kIsWeb) {
      final bytes = result.files.single.bytes ?? Uint8List(0);
      final stringData = const Utf8Decoder().convert(bytes);
      return stringData;
    }
    else {
      final preferencesPath = result.files.single.path;
      if (preferencesPath == null) {
        if (context.mounted) {
          await AlertMessageDialog(context).show(
              title: 'Error loading file', message: 'path is empty');
        }
        return null;
      }
      return preferencesPath;
    }
  }
}