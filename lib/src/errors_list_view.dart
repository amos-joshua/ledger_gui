import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/model.dart';

class ErrorsListView extends StatelessWidget {
  const ErrorsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<AppModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
      ),
      body: ListView.builder(
        itemCount: model.errors.length,
        itemBuilder: (context, index) {
          final item = model.errors[model.errors.length - index - 1];
          return ExpansionTile(
            title: Text(item.message),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              SelectableText('${item.message}\n${item.stackTrace?.toString() ?? '(no stack trace)'}', style: const TextStyle(fontFamily: 'monospace'))
            ],
          );
        }
      )
    );
  }
}
