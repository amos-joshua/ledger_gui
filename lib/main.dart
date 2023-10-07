import 'package:flutter/material.dart';

import 'src/controller/app_controller.dart';
import 'src/app_scaffold.dart';
import 'src/dependencies.dart';


void main() {
  runApp(
    DependenciesProvider(
      appController: AppController(),
      child: MaterialApp(
          title: 'Ledger CLI Explorer',
          theme: ThemeData(primarySwatch: Colors.green),
          home: const AppScaffold()
      )
    )
  );
}
