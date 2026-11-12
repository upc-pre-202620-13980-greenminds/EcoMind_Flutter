import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/presentation/notification_preferences/notification_preferences_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Frame 83
class NotificationPreferencesPage extends StatefulWidget {
  final NotificationPreferencesViewModel viewModel;
  const new({super.key, required this.viewModel});

  @override
  State<NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;

    return SecondaryScaffold(
      title: l10n.preferencesTitle,
      isInsideInbox: true,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          final state = viewModel.state;
          final preferences = state.preferences;
          final colorScheme = Theme.of(context).colorScheme;

          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(semanticsLabel: l10n.loading),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.preferencesDescription,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                // Light card with a thin border that groups the rows
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      _PreferenceRow(
                        title: l10n.preferencesAchievements,
                        description: l10n.preferencesAchievementsDescription,
                        value: preferences.achievements,
                        onChanged: (value) => viewModel.update(
                          preferences.copyWith(achievements: value),
                        ),
                      ),
                      const _RowDivider(),
                      _PreferenceRow(
                        title: l10n.preferencesWeekly,
                        description: l10n.preferencesWeeklyDescription,
                        value: preferences.weeklySummary,
                        onChanged: (value) => viewModel.update(
                          preferences.copyWith(weeklySummary: value),
                        ),
                      ),
                      const _RowDivider(),
                      _PreferenceRow(
                        title: l10n.preferencesEvents,
                        description: l10n.preferencesEventsDescription,
                        value: preferences.communityEvents,
                        onChanged: (value) => viewModel.update(
                          preferences.copyWith(communityEvents: value),
                        ),
                      ),
                      const _RowDivider(),
                      _PreferenceRow(
                        title: l10n.preferencesActivity,
                        description: l10n.preferencesActivityDescription,
                        value: preferences.communityActivity,
                        onChanged: (value) => viewModel.update(
                          preferences.copyWith(communityActivity: value),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.saveFailed)
                  FormErrorText(message: l10n.preferencesSaveFailed),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Title, description and switch; the whole row changes the value
class _PreferenceRow extends StatelessWidget {
  const new({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // The screen reader says the title, the description and the state as one control
    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Material switch on Android and the iOS one on iPhone, as the course guide recommends
                Switch.adaptive(value: value, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
