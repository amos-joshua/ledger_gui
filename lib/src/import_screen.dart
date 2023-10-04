import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'dialogs/dialogs.dart';
import 'import_starter.dart';

class ImportScreen extends StatefulWidget {
  final ImportSession importSession;
  final LedgerPreferences ledgerPreferences;
  const ImportScreen({required this.importSession, required this.ledgerPreferences, super.key});

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
            onPressed: () {
              final importStarter = ImportStarter();
              importStarter.startImport(
                  context,
                  ledgerPreferences: widget.ledgerPreferences,
                  accountManager: importSession.accountManager,
                  ongoingImportSession: importSession
              ).then((importSession) {
                if (importSession == null) return;
                setState((){});
              });
            },
          ),
          ElevatedButton(
            child: const Text('Save...'),
            onPressed: () {
              ConfirmDialog(context).show(
                title: 'Save imports',
                message: '${importSession.summary()}?'
              ).then((confirmed) {
                if (confirmed != true) return;
                importSession.saveTo(widget.ledgerPreferences.defaultLedgerFile).then((placeholder) {
                  AlertMessageDialog(context).show(
                    title: 'Import succeeded',
                    message: ''
                  ).then((placeholder) {
                    Navigator.of(context).pop();
                  });
                }).onError((error, stackTrace) {
                  AlertMessageDialog(context).show(
                    title: 'Oops',
                    message: 'Error importing entries: $error\n$stackTrace'
                  );
                });
              });
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