import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

import 'dialogs/error_dialog.dart';
class ImportStarter {
  static const csvDataLoader = CsvDataLoader();

  Future<ImportSession?> startImport(BuildContext context, {required LedgerPreferences ledgerPreferences, required AccountManager accountManager, ImportSession? ongoingImportSession}) {
    final selectAccountDialog = ImportAccountDialog(context);
    return selectAccountDialog.show(ledgerPreferences.importAccounts).then((importAccount) {
      if (importAccount == null) return Future.value(null);
      return FilePicker.platform.pickFiles(initialDirectory: ledgerPreferences.defaultCsvImportDirectory).then((result) {
        if (result == null) return Future.value(null);
        if (result.files.isEmpty) return Future.value(null);
        final importSession = ongoingImportSession ?? ImportSession(accountManager: accountManager);
        final csvFilePath = result.files.first.path;
        if (csvFilePath == null) {
          throw "No file chosen";
        }
        final csvLines = csvDataLoader.openStreamFromFile(csvFilePath, csvFormat: importAccount.csvFormat);
        return importSession.loadCsvLines(csvLines, importAccount: importAccount).then((placeholder) => importSession);
      }).catchError((err, stackTrace) {
        ErrorDialog(context).show('Oops', 'Could not import file: $err\n\n$stackTrace');
      });
    });
  }
}