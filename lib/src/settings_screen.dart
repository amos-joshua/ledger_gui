import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ledger_cli/ledger_cli.dart';
import 'dialogs/dialogs.dart';
import 'controller/app_controller.dart';

class SettingsScreen extends StatefulWidget {
  final AppController appController;
  const SettingsScreen({required this.appController, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SettingsScreen> {

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

  void forgetPreferences() async {
    final confirm = await ConfirmDialog(context).show(
      title: 'Forget preferences...',
      message: 'App will reset to its initial state. Continue?'
    );
    if (confirm != true) return;
    widget.appController.forgetPreferences();
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    final desktopPropertyStyle = kIsWeb ? TextStyle(color: Colors.blueGrey) : null;
    final desktopOnly = kIsWeb ? " (desktop only)" : "";
    final preferences = widget.appController.model.preferences.value;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Preferences'),
          actions: [
            IconButton(
                onPressed: forgetPreferences,
                icon: Icon(Icons.delete),
                hoverColor: Colors.red
            )
          ],
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
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                String data = 'loading ...';
                if (snapshot.hasData) {
                  data = '${snapshot.data?.version}';
                }
                else if (snapshot.hasError) {
                  data = 'Error: ${snapshot.error}';
                }

                return ListTile(
                    title: Text('Ledger GUI version: $data')
                );
              },
            ),
          ]
        )
    );
  }

}
