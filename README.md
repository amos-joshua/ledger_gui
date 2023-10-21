# Ledger GUI

A GUI for browsing [ledger-cli](https://ledger-cli.org/) files and
importing CSV bank statements.

Targets the desktop, but should run on mobile / web as well.

## Web demo

A web version is available as a demo: https://amos-joshua.github.io/ledger_gui_website/

This version is entirely self-contained and runs purely on the clientside (there is no backend, no 
data is sent off the device). The preferences file is stored in client-local storage.

You can use the sample preferences, ledger and csv import from the
[samples](samples) directory to test the app.

## Usage

On first run of the app, select a preferences file (see [samples/ledger-preferences.json](samples/ledger-preferences.json)).
Then (if necessary, e.g. on web) select a ledger file.

### Preferences

The preferences file is a json file containing a hash with the following structure:
 
  - *defaultLedgerFile*: the default ledger file to load at startup (ignored in the browser)
  - *defaultCsvImportDirectory*: the initial folder for the open-file dialog for imports (ignored in the browser)
  - *csvFormats*: a list of hashes, each of which describes how to parse csv files from a different bank, with the following keys:
    - *name*
    - *dateColumnIndex*: column number of the transaction's date in the CSV file (first column has index 0)
    - *descriptionColumnIndex*: column number of the transaction's description in the CSV file
    - *amountColumnIndex*: column number of the amount in the CSV file
    - *dateFormat*: format of the transaction's date, e.g. `mm/dd/YY`
    - *numberFormat*: format of the transaction's amount, eg. `###.##` or `###,##`
    - *locale*: locale for interpreting the description fields, e.g. `en_US`
    - *lineSkip*: number of lines to skip at the beginning of a CSV file. Useful for skipping headers
    - *valueSeparator*: field separator in the CSV file, usually `,` or `;`
    - *quoteCharacter*: if non-empty, this character is stripped from the beginning and end of each field (if present)
  - *importAccounts*: a list of hashes, each of which describes an account into which CSV statements may be imported, with the following keys:
    - *label*
    - *sourceAccount*: the (ledger-cli) account into which the transactions will be imported, e.g. `Assets:checking`
    - *currency*: the currency used by this account, e.g. `USD`
    - *format*: the name of a CSV format defined in the same preferences file
    - *defaultDestinationAccount*: the (ledger-cli) account to assign to imported transactions for which no destination account is specified, e.g. `Expenses:misc`

## Account matching for imports

Ledger_gui allows automatically matching transactions in csv
statements to accounts. Matching strings are specified as comma-separated quoted substrings in a comment after the account definition in the ledger file, for example:

```
account Expenses:restaurants             # "FALAFEL", "PIZZA"
```

will cause any transactions with `FALAFEL` or `PIZZA` in their
description to be matched to the `Expenses:restaurants` account (the
matching is case insensitive).

This is not part of the ledger-cli format, but a custom extension
implemented by ledger_gui.

## Running from source

    flutter run
