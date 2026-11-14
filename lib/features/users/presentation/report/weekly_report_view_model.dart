import 'package:ecomind_parents/features/users/application/get_weekly_report_use_case.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/report/weekly_report_state.dart';
import 'package:flutter/material.dart';

// Shared by the card of the Profile tab and the report screen
class WeeklyReportViewModel extends ChangeNotifier {
  final GetWeeklyReportUseCase getWeeklyReport;

  new({required this.getWeeklyReport});

  WeeklyReportState _state = WeeklyReportState();
  WeeklyReportState get state => _state;

  // The family used last time, so "Try again" can ask for the same report
  Family? _family;

  Future<void> loadReport(Family? family) async {
    _family = family;
    if (family == null) {
      _state = WeeklyReportState();
      notifyListeners();
      return;
    }

    // A new initial state, so the report of another family is never shown
    _state = WeeklyReportState().copyWith(hasFamily: true, isLoading: true);
    notifyListeners();

    WeeklyReportState result;
    try {
      final report = await getWeeklyReport.execute(family);
      result = _state.copyWith(report: report, isLoading: false);
    } on UsersException catch (e) {
      result = _state.copyWith(isLoading: false, errorMessage: e.error);
    } catch (e) {
      result = _state.copyWith(
        isLoading: false,
        errorMessage: UsersError.unknown,
      );
    }

    // If the family changed while waiting, a newer request is running
    if (!identical(_family, family)) {
      return;
    }
    _state = result;
    notifyListeners();
  }

  Future<void> retry() => loadReport(_family);
}
