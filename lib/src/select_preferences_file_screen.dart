import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/app_controller.dart';
import 'dialogs/dialogs.dart';

class SelectPreferencesFileScreen extends StatelessWidget {
  const SelectPreferencesFileScreen({super.key});

  void onSelectFileTapped(BuildContext context) async {
    final appController = context.read<AppController>();
    final pathOrData = await SelectPreferencesFileDialog(context).show();
    if (pathOrData == null) return;
    final data = kIsWeb ? pathOrData : await File(pathOrData).readAsString();
    appController.loadPreferences(data);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: () => onSelectFileTapped(context),
            child: const Text('Select preferences file...')
        )
    );
  }

}