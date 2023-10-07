import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dialogs/dialogs.dart';
import 'model/model.dart';

class SelectLedgerFileScreen extends StatelessWidget {
  const SelectLedgerFileScreen({super.key});

  void onSelectFileTapped(BuildContext context) {
    final preferences = context.read<AppModel>().preferences.value;
    final ledgerSource = context.read<LedgerSourceAttr>();
    final initialDirectory = kIsWeb ? null : File(preferences.defaultLedgerFile).parent.path;
    SelectLedgerFileDialog(context).show(initialDirectory: initialDirectory).then((source) {
      if (source != null) {
        ledgerSource.value = source;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: () => onSelectFileTapped(context),
          child: const Text('Select ledger file...')
        )
    );
  }

}