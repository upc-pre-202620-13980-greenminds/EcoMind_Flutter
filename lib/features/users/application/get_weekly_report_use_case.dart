import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_report_repository.dart';
import 'package:ecomind_parents/features/users/domain/family_weekly_report.dart';

class GetWeeklyReportUseCase {
  final FamilyReportRepository repository;

  const new({required this.repository});

  Future<FamilyWeeklyReport> execute(Family family) {
    return repository.getWeeklyReport(family);
  }
}
