import 'package:flutter/material.dart';
import 'package:ledger_gui/src/model/attributes.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'entries_list_tab.dart';
import 'evolutions_tab.dart';
import 'balance_tab.dart';

class AppTabView extends StatefulWidget {
  final TabController tabController;

  const AppTabView({required this.tabController, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AppTabView> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final tabQueries = context.watch<QueryList>();
    return TabBarView(
        controller: widget.tabController,
        children: [
          const BalanceTab(),
          ...tabQueries.map((tabQuery) => //Center(child: Text(tab.accounts.join(' '))))
            tabQuery.value.groupBy == null ?
            EntriesListTab(query: tabQuery) :
            EvolutionsTab(query: tabQuery)
          )
        ]
    );
  }
}