import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'controller/app_controller.dart';
import 'model/model.dart';

class BalanceTab extends StatefulWidget {
  const BalanceTab({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BalanceTab> {
  static const queryExecutor = QueryExecutor();
  late final ValueNotifier<Query> query;
  late final Ledger ledger;
  late final AppController appController;
  BalanceResult? balanceResult;

  @override
  void initState() {
    super.initState();
    ledger = context.read<AppModel>().ledger;
    query = context.read<BalancesQueryAttr>();
    appController = context.read<AppController>();
    loadBalances();
  }

  Future<void> loadBalances() async {
    try {
      final balanceResult = queryExecutor.queryBalance(ledger, query.value);
      setState(() {
        this.balanceResult = balanceResult;
      });
    }
    catch (error, stackTrace) {
      print("Query error: $error \n$stackTrace");
    }

    query.addListener(loadBalances);
  }

  @override
  void dispose() {
    query.removeListener(loadBalances);
    super.dispose();
  }

  void showEntriesScreen(List<String> accounts, [DateRange? dateRange]) {
    appController.addAccountTab(accounts);
  }

  void showEvolutionScreen(List<String> accounts) {
    appController.addAccountTab(accounts, groupBy: true);
  }

  List<Widget> balancesActionsFor(BuildContext context, String account) {
    return [
      IconButton(
          onPressed: () => showEntriesScreen([account]),
          icon: const Icon(Icons.list, color: Colors.black54),
          tooltip: 'Transactions...'
      ),
      IconButton(
          onPressed: () => showEvolutionScreen([account]),
          icon: const Icon(Icons.trending_up, color: Colors.black54),
          tooltip: 'Evolution...'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appController = context.read<AppController>();

    final balanceResult = this.balanceResult;
    if (balanceResult == null) return const Center(child: CircularProgressIndicator());
    return BalanceTable(
        key: ValueKey(balanceResult.hashCode),
        balanceResult: balanceResult,
        onDoubleTap: (account) {
          appController.addAccountTab([account]);
        },
        actionsBuilder: balancesActionsFor
    );
  }

}