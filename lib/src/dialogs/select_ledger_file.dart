import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'package:file_picker/file_picker.dart';
import 'alert.dart';

class SelectLedgerFileDialog {
  final BuildContext context;
  SelectLedgerFileDialog(this.context);

  Future<LedgerSource?> show({String? initialDirectory}) async {
    final result = await FilePicker.platform.pickFiles(initialDirectory: initialDirectory);
    if (result == null) return null;
    if (kIsWeb) {
      final bytes = result.files.single.bytes ?? Uint8List(0);
      final stringData = const Utf8Decoder().convert(bytes);
      return LedgerSource.forData(stringData);
    }
    else {
      final ledgerPath = result.files.single.path;
      if (ledgerPath == null) {
        if (context.mounted) {
          await AlertMessageDialog(context).show(
              title: 'Error loading file', message: 'path is empty');
        }
        return null;
      }
      return LedgerSource.forFile(ledgerPath);
    }
  }
}