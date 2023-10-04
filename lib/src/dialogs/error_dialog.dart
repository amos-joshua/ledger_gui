import 'package:flutter/material.dart';

class ErrorDialog {
  BuildContext context;
  ErrorDialog(this.context);

  Future<void> show(String title, String message) {
    return showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
    );
  }
}