import 'package:flutter/material.dart';

class ConfirmDialog {
  final BuildContext context;
  ConfirmDialog(this.context);

  Future<bool?> show({required String title, required String message, String cancelLabel = 'Cancel', String confirmLabel = 'Confirm', Color cancelColor = Colors.black, Color confirmColor = Colors.black, bool barrierDismissable = true}) {
    return showDialog(
        context: context,
        barrierDismissible: barrierDismissable,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(cancelLabel, style: TextStyle(color: cancelColor))
            ),
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(confirmLabel, style: TextStyle(color: confirmColor))
            )
          ],
        )
    );
  }
}