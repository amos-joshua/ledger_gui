import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'dialogs/dialogs.dart';
import 'import_starter.dart';
import 'model/model.dart';

class ImportScreen extends StatefulWidget {
  final ImportSession importSession;
  final LedgerPreferences ledgerPreferences;
  final void Function(UserFacingError error) onImportError;
  final void Function(Iterable<Entry> newEntries) onAddEntriesToLedger;
  const ImportScreen({required this.importSession, required this.ledgerPreferences, required this.onImportError, required this.onAddEntriesToLedger, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ImportScreen> {
  static const pendingImportSerializer = PendingImportSerializer();
  ImportSession get importSession => widget.importSession;

  Future<String> serializePendingEntries() async {
    final pendingEntries = importSession.pendingEntries;
    return pendingImportSerializer.serialize(pendingEntries);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import'),
        actions: [
          ElevatedButton(
            child: const Text('Add...'),
            onPressed: () async {
              final importStarter = ImportStarter();
              try {
                final newSession = await importStarter.startImport(
                    context,
                    ledgerPreferences: widget.ledgerPreferences,
                    accountManager: importSession.accountManager,
                    ongoingImportSession: importSession
                );
                if (newSession == null) return;
                setState(() {});
              }
              catch (exc, stackTrace) {
                widget.onImportError(UserFacingError(message: '$exc', stackTrace: stackTrace));
              }
            },
          ),
          ElevatedButton(
            child: const Text('Save...'),
            onPressed: () async{
              final confirm = await ConfirmDialog(context).show(
                title: 'Save imports',
                message: '${importSession.summary()}?'
              );
              if (confirm != true) return;
              try {
                if (kIsWeb) {
                  widget.onAddEntriesToLedger(importSession.pendingEntriesAsEntries());
                }
                else {
                  await importSession.saveTo(widget.ledgerPreferences.defaultLedgerFile);
                }
                await AlertMessageDialog(context).show(
                    title: 'Import succeeded',
                    message: ''
                );
                Navigator.of(context).pop();
              }
              catch (error, stackTrace) {
                AlertMessageDialog(context).show(
                  title: 'Oops',
                  message: 'Error importing entries: $error\n$stackTrace'
                );
              }
            },
          )
        ],
      ),
      body: PendingEntryList(
        pendingEntries: importSession.pendingEntries,
        accountManager: importSession.accountManager
      )
    );
  }

}