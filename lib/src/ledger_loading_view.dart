import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'controller/app_controller.dart';
import 'select_ledger_file_screen.dart';
import 'select_preferences_file_screen.dart';
import 'model/model.dart';
import 'shimmer_list.dart';

class LedgerLoadingView extends StatefulWidget {
  final Widget child;
  const LedgerLoadingView({required this.child, super.key});

  @override
  State createState() => _State();
}

class _State extends State<LedgerLoadingView> {
  late final AppController appController;
  LedgerSource? lastLoadedSource;


  @override
  void initState() {
    super.initState();
    appController = context.read<AppController>();
    appController.model.ledgerSource.addListener(loadLedger);
    appController.tryLoadStoredPreferences();
  }

  @override
  void dispose() {
    super.dispose();
    appController.model.ledgerSource.removeListener(loadLedger);
  }

  void loadLedger() {
    final ledgerSource = appController.model.ledgerSource.value;
    if (ledgerSource != null) {
      appController.loadLedger(ledgerSource);
    }
  }

  @override
  Widget build(BuildContext context) {
    final guiState = context.watch<GuiInitStateAttr>().value;
    final loading = (guiState == GuiInitState.loadingPreferences) || (guiState == GuiInitState.loadingLedger);
    final hasNoLedger = guiState == GuiInitState.hasNoLedger;
    final hasNoPreferences = guiState == GuiInitState.hasNoPreferences;
    if (loading) return const ShimmerList();
    if (hasNoLedger) return const SelectLedgerFileScreen();
    if (hasNoPreferences) return const SelectPreferencesFileScreen();
    return widget.child;
  }
}