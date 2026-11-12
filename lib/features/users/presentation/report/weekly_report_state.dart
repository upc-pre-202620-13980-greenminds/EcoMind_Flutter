import 'package:ecomind_parents/features/users/domain/family_weekly_report.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class WeeklyReportState {
  const new({
    this.report,
    this.hasFamily = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final FamilyWeeklyReport? report;
  // Without a family there is no report: the card invites to create one
  final bool hasFamily;
  final bool isLoading;
  final UsersError? errorMessage;

  // The error is not kept by copyWith: a new change clears it.
  // To clear the report, the ViewModel starts again from a new WeeklyReportState
  WeeklyReportState copyWith({
    FamilyWeeklyReport? report,
    bool? hasFamily,
    bool? isLoading,
    UsersError? errorMessage,
  }) {
    return WeeklyReportState(
      report: report ?? this.report,
      hasFamily: hasFamily ?? this.hasFamily,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
