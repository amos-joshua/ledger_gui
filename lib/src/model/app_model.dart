import 'package:ledger_cli/ledger_cli.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'attributes.dart';
import 'user_facing_error.dart';
import 'gui_init_state.dart';

class AppModel {
  final guiInitState = GuiInitStateAttr(GuiInitState.loadingPreferences);
  var ledgerPreferences = LedgerPreferences.empty;

  var ledgerSource = LedgerSourceAttr(null);
  var ledger = Ledger();
  var errors = <UserFacingError>[];

  var balancesQuery = BalancesQueryAttr(Query(accounts: ['Assets']));

  final tabQueries = QueryList();
  final selectedTabIndex = SelectedTabIndexAttr(0);

}