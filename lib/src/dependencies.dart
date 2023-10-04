import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/app_controller.dart';

class DependenciesProvider extends StatelessWidget {
  final AppController appController;
  final Widget child;

  const DependenciesProvider({required this.appController, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider.value(value: appController),
          Provider.value(value: appController.model),
          ChangeNotifierProvider.value(value: appController.model.guiInitState),
          ChangeNotifierProvider.value(value: appController.model.ledgerSource),
          ChangeNotifierProvider.value(value: appController.model.balancesQuery),
          ChangeNotifierProvider.value(value: appController.model.tabQueries),
          ChangeNotifierProvider.value(value: appController.model.selectedTabIndex)
        ],
      child: child,
    );
  }
}