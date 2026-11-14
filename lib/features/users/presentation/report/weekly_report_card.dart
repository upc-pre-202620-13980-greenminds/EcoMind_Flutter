import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/features/users/presentation/report/weekly_report_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// "Family weekly report" card of the Profile tab (frame 24)
class WeeklyReportCard extends StatelessWidget {
  const new({
    super.key,
    required this.viewModel,
    required this.onViewReport,
    required this.onCreateFamily,
  });
  final WeeklyReportViewModel viewModel;
  final VoidCallback onViewReport;
  // Without a family the card invites to create one instead of opening the report
  final VoidCallback onCreateFamily;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final bodyStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      color: colorScheme.onSurface,
    );

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final state = viewModel.state;
        final report = state.report;

        final List<Widget> lines;
        if (!state.hasFamily) {
          lines = [Text(l10n.weeklyReportNoFamily, style: bodyStyle)];
        } else if (state.isLoading) {
          lines = [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  semanticsLabel: l10n.loading,
                ),
              ),
            ),
          ];
        } else if (report == null) {
          lines = [Text(l10n.tabError, style: bodyStyle)];
        } else if (!report.hasData) {
          lines = [Text(l10n.weeklyReportNoData, style: bodyStyle)];
        } else {
          lines = [
            Text(
              l10n.weeklyReportQuests(
                report.completedQuests,
                report.totalQuests,
              ),
              style: bodyStyle,
            ),
            Text(
              l10n.weeklyReportAchievements(report.achievementsEarned),
              style: bodyStyle,
            ),
          ];
        }

        return Card.outlined(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 4, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          l10n.weeklyReportTitle,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    state.hasFamily
                        ? TextLink(
                            text: l10n.weeklyReportView,
                            color: colorScheme.onSurfaceVariant,
                            onPressed: onViewReport,
                          )
                        : TextLink(
                            text: l10n.familyCreate,
                            onPressed: onCreateFamily,
                          ),
                  ],
                ),
                ...lines,
              ],
            ),
          ),
        );
      },
    );
  }
}
