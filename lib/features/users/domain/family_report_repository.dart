import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_weekly_report.dart';

abstract class FamilyReportRepository {
  // Report of the current week, from Monday to Sunday
  Future<FamilyWeeklyReport> getWeeklyReport(Family family);
}
