import 'package:ledger_cli/ledger_cli.dart';

enum  AppTabType {
  transactions, evolution
}

class AppTab {
  final Query query;
  final AppTabType appTabType;
  AppTab({required this.query, required this.appTabType});
}