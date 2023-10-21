import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'controller/app_controller.dart';
import 'model/model.dart';

class EntriesListTab extends StatefulWidget {
  final ValueNotifier<Query> query;
  const EntriesListTab({required this.query, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EntriesListTab> {
  static const queryExecutor = QueryExecutor();
  final List<Entry> filteredEntries = [];
  late final AppController appController;
  late final Ledger ledger;
  ValueNotifier<Query> get query => widget.query;

  @override
  void initState() {
    super.initState();
    ledger = context.read<AppModel>().ledger;
    appController = context.read<AppController>();

    loadEntries();
    query.addListener(loadEntries);
    appController.model.ledgerNonce.addListener(loadEntries);
  }

  @override
  void dispose() {
    query.removeListener(loadEntries);
    appController.model.ledgerNonce.removeListener(loadEntries);
    super.dispose();
  }

  loadEntries() {
    Future(() => queryExecutor.queryFilter(ledger, query.value)).then((filterResult) {
      final entries = filterResult.matches;
      entries.sort((entry1, entry2) => entry2.date.compareTo(entry1.date));

      setState(() {
        filteredEntries.clear();
        filteredEntries.addAll(entries);
      });
    }).catchError((error, stackTrace) {
      print("Query error: $error \n$stackTrace");
    });
  }

  @override
  Widget build(BuildContext context) {
    return LedgerEntryList(
        entries: filteredEntries,
    );
  }

}