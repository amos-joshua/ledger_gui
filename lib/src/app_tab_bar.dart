import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:provider/provider.dart';

import 'model/model.dart';
import 'entries_tab_label.dart';


class AppTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;

  const AppTabBar({required this.tabController, super.key});

  @override
  State<StatefulWidget> createState() => _State();

  @override
  Size get preferredSize => const Size(double.maxFinite, 90.0);
}

class _State extends State<AppTabBar> {
  late final AppModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<AppModel>();
  }

  @override
  Widget build(BuildContext context) {
    final tabQueries = context.watch<QueryList>();
    final selectedTabIndex = context.watch<SelectedTabIndexAttr>().value;
    final ledgerSource = context.watch<LedgerSourceAttr>().value;

    final showQueryEditor = ledgerSource != null;
    final query = selectedTabIndex == 0 ? model.balancesQuery : tabQueries.queryAt(selectedTabIndex - 1);
    final mediaQuery = MediaQuery.of(context);

    return
      Column(
        children:[
          SizedBox(
            width: mediaQuery.size.width,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: widget.tabController,
              tabs:[
                const Tab(text: 'Balances'),
                ...tabQueries.asMap().entries.map((entry) => EntriesTabLabel(
                    index: entry.key + 1,
                    icon: entry.value.value.groupBy == null ? Icons.list : Icons.trending_up,
                    label: entry.value.value.accounts.join(','),
                    onDelete: () {
                      setState(() {
                        if (model.selectedTabIndex.value == tabQueries.length) {
                          model.selectedTabIndex.value -= 1;
                        }
                        tabQueries.removeAt(entry.key);
                      });
                    },
                    tabController: widget.tabController
                  )
                )
              ]
            )
          ),
          if (showQueryEditor) QueryEditorBar(
              query: query,
              ledger: model.ledger,
              allowGroupedBy: query.value.groupBy != null,
              searchFiltersAccounts: selectedTabIndex == 0,
          )
        ]
      );
  }
}