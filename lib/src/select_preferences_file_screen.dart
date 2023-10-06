
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/app_controller.dart';
import 'dialogs/dialogs.dart';

class SelectPreferencesFileScreen extends StatelessWidget {
  const SelectPreferencesFileScreen({super.key});

  void onSelectFileTapped(BuildContext context) {
    final appController = context.read<AppController>();

    SelectPreferencesFileDialog(context).show().then((path) {
      if (path != null) {
        appController.loadPreferences(path);
      }
    });
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