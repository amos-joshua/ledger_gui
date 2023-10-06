import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ledger_cli_flutter/ledger_cli_flutter.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'dialogs/dialogs.dart';
import 'import_starter.dart';

class SettingsScreen extends StatefulWidget {
  final LedgerPreferences ledgerPreferences;
  const SettingsScreen({required this.ledgerPreferences, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SettingsScreen> {
  LedgerPreferences get preferences => widget.ledgerPreferences;

  String summarize(CsvFormat format) {
    return """dateColumnIndex: ${format.dateColumnIndex}
descriptionColumnIndex: ${format.descriptionColumnIndex}
amountColumnIndex: ${format.amountColumnIndex}
dateFormat: ${format.dateFormat}
numberFormat: ${format.numberFormat}
locale: ${format.locale}
lineSkip: ${format.lineSkip}
valueSeparator: ${format.valueSeparator}
quoteCharacter: ${format.quoteCharacter}
""";
  }
  
  @override
  Widget build(BuildContext context) {
    final desktopPropertyStyle = kIsWeb ? TextStyle(color: Colors.blueGrey) : null;
    final desktopOnly = kIsWeb ? " (desktop only)" : "";

    return Scaffold(
        appBar: AppBar(
          title: const Text('Preferences'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text('Default ledger file$desktopOnly', style: desktopPropertyStyle),
              subtitle: Text(preferences.defaultLedgerFile)
            ),
            ListTile(
              title: Text('Default CSV import directory$desktopOnly', style: desktopPropertyStyle),
              subtitle: Text(preferences.defaultCsvImportDirectory)
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text('Import accounts'),
              childrenPadding: const EdgeInsets.only(left: 50),
              children: preferences.importAccounts.map((importAccount) => ListTile(
                  isThreeLine: true,
                  title: Text('${importAccount.label} (${importAccount.currency})'),
                  subtitle: Text('default account: ${importAccount.defaultDestinationAccount}\ncsv format: ${importAccount.csvFormat.name}'),
                )
              ).toList(growable: false)
            ),
            ExpansionTile(
              initiallyExpanded: true,
              title: Text('Csv formats'),
                childrenPadding: const EdgeInsets.only(left: 50),
                children: preferences.csvFormats.map((csvFormat) => ListTile(
                title: Text(csvFormat.name),
                onTap: () {
                  AlertMessageDialog(context).show(
                    title: "CSV Format '${csvFormat.name}'",
                    message: summarize(csvFormat)
                  );
                }
              )
              ).toList(growable: false)
            ),
          ]
        )
    );
  }

}
