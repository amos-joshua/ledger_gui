import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'controller/app_controller.dart';
import 'model/model.dart';

class EvolutionsTab extends StatefulWidget {
  final ValueNotifier<Query> query;

  const EvolutionsTab({required this.query, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EvolutionsTab> {
  static const queryExecutor = QueryExecutor();
  late final Ledger ledger;
  late final AppController appController;
  ValueNotifier<Query> get query => widget.query;
  BalanceResult? balanceResult;

  @override
  void initState() {
    super.initState();
    ledger = context.read<AppModel>().ledger;
    appController = context.read<AppController>();

    loadBalances();
    query.addListener(loadBalances);
  }

  @override
  void dispose() {
    query.removeListener(loadBalances);
    super.dispose();
  }

  List<Widget> evolutionsActionSFor(BuildContext context, String account, DateRange? dateRange) {
    return [
      IconButton(
          icon: const Icon(Icons.list, color: Colors.black54),
          onPressed: () => appController.addAccountTab([account], dateRange: dateRange),
          tooltip: 'Transactions...'
      ),
    ];
  }

  loadBalances() {
    Future(() => queryExecutor.queryBalance(ledger, query.value)).then((balanceResult) {
      setState(() {
        this.balanceResult = balanceResult;
      });
    }).catchError((error, stackTrace) {
      print("Query error: $error \n$stackTrace");
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceResult = this.balanceResult;
    if (balanceResult == null) return const Center(child:CircularProgressIndicator());
    return EvolutionsTable(
      key: ValueKey(balanceResult.hashCode),
      actionsBuilder: evolutionsActionSFor,
      balanceResult: balanceResult,
    );
  }

}