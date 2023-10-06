import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ledger_cli/ledger_cli.dart';

import '../model/model.dart';

class AppController  {
  static const ledgerPreferencesLoader = LedgerPreferencesLoader();
  static const ledgerLoader = LedgerLoader();
  late final ledgerSourceWatcher = LedgerSourceWatcher(
    onSourceChanged: (source) => model.ledgerSource.value = source
  );

  final _errorStreamController = StreamController<UserFacingError>.broadcast();
  Stream<UserFacingError> get errorStream => _errorStreamController.stream;

  void addError(UserFacingError error, {bool propagateToGui = false}) {
    model.errors.add(error);
    if (propagateToGui) {
      _errorStreamController.add(error);
    }
  }

  final model = AppModel();

  Future<void> loadPreferences(String pathOrData) async {
    model.guiInitState.value = GuiInitState.loadingPreferences;
    try {
      final preferences = kIsWeb ? await ledgerPreferencesLoader.loadFromStringData(pathOrData) : await ledgerPreferencesLoader.loadFromPath(pathOrData);
      model.ledgerPreferences = preferences;
      if (kIsWeb) {
        model.guiInitState.value = GuiInitState.hasNoLedger;
      }
      else {
        model.ledgerSource.value =
            LedgerSource.forFile(preferences.defaultLedgerFile);
      }
    }
    catch (exc, stackTrace) {
      addError(UserFacingError(message: 'Error loading ledger preferences: $exc', stackTrace: stackTrace), propagateToGui: true);
      model.guiInitState.value = GuiInitState.hasNoPreferences;
    }
  }

  Future<void> loadLedger(LedgerSource source) async {
    model.guiInitState.value = GuiInitState.loadingLedger;
    try {
      model.ledger = await ledgerLoader.load(source, onApplyFailure: (edit, exc, stackTrace) {
        final userError = UserFacingError(message: edit != null ? 'Could not apply $edit: $exc' : '$exc', stackTrace: stackTrace);
        addError(userError, propagateToGui: exc is PathNotFoundException);
      });
      ledgerSourceWatcher.watch(source);
      model.guiInitState.value = GuiInitState.ledgerLoaded;
    }
    catch (exc, stackTrace) {
      addError(UserFacingError(message: 'Error loading ledger from $source: $exc', stackTrace: stackTrace));
      model.guiInitState.value = GuiInitState.hasNoLedger;
    }
  }

  void addAccountTab(List<String> accounts, {bool groupBy = false, DateRange? dateRange}) {
    final newQuery = Query()..accounts = accounts;
    if (groupBy) {
      newQuery.groupBy = PeriodLength.month;
      newQuery.startDate = DateTime(DateTime.now().year, 01, 01);
    }
    if (dateRange != null) {
      newQuery.startDate = dateRange.startDateInclusive;
      newQuery.endDate = dateRange.endDateInclusive;
    }
    model.tabQueries.add(newQuery);
    model.selectedTabIndex.value = model.tabQueries.length;
  }
}