import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';

class ImportStarter {
  static const csvDataLoader = CsvDataLoader();

  Future<ImportSession?> startImport(BuildContext context, {required LedgerPreferences ledgerPreferences, required AccountManager accountManager, ImportSession? ongoingImportSession}) {
    final selectAccountDialog = ImportAccountDialog(context);
    return selectAccountDialog.show(ledgerPreferences.importAccounts).then((importAccount) {
      if (importAccount == null) return Future.value(null);
      return FilePicker.platform.pickFiles(initialDirectory: ledgerPreferences.defaultCsvImportDirectory).then((result) {
        if (result == null) return Future.value(null);
        String pathOrData = "";
        if (kIsWeb) {
          final bytes = result.files.single.bytes ?? Uint8List(0);
          pathOrData = const Utf8Decoder().convert(bytes);
        }
        else {
          if (result.files.isEmpty) return Future.value(null);
          final path = result.files.first.path;
          if (path == null) throw "No file chosen";
          pathOrData = path;
        }
        final importSession = ongoingImportSession ?? ImportSession(accountManager: accountManager);
        final csvLines = switch(kIsWeb) {
          false => csvDataLoader.openStreamFromFile(pathOrData, csvFormat: importAccount.csvFormat),
          true =>  csvDataLoader.openStreamFromStringData(Stream.value(pathOrData), csvFormat: importAccount.csvFormat)
        };
        return importSession.loadCsvLines(csvLines, importAccount: importAccount).then((placeholder) => importSession);
      });
    });
  }
}