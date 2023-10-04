import 'package:flutter/material.dart';

class AlertMessageDialog {
  final BuildContext context;
  AlertMessageDialog(this.context);

  Future<bool?> show({required String title, required String message, String okLabel = 'Ok', Color okColor = Colors.black, bool barrierDismissable = true}) {
    return showDialog(
        context: context,
        barrierDismissible: barrierDismissable,
        builder: (dialogContext) => AlertDialog(
          title: SelectableText(title),
          content: SelectableText(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(okLabel, style: TextStyle(color: okColor))
            )
          ],
        )
    );
  }
}