import 'package:ecomind_parents/features/quests/domain/quest_filters.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class QuestFilterPanel extends StatefulWidget {
  const new({super.key, required this.initial, required this.onApply});

  final QuestFilters initial;
  final ValueChanged<QuestFilters> onApply;

  @override
  State<QuestFilterPanel> createState() => _QuestFilterPanelState();
}

class _QuestFilterPanelState extends State<QuestFilterPanel> {
  late final _categories = widget.initial.categories.toSet();
  late final _types = widget.initial.types.toSet();
  late final _ages = widget.initial.ages.toSet();
  late final _minutes = widget.initial.minutes.toSet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              _section(l10n.questsFilterCategory, {
                'ENERGY': l10n.questsEnergy,
                'WATER': l10n.questsWater,
                'RECYCLE': l10n.questsRecycle,
              }, _categories),
              _section(
                l10n.questsFilterType,
                {
                  'COLLABORATIVE': l10n.questsCollaborative,
                  'MINIGAME': l10n.questsFilterMinigame,
                  'ACTIVITIES': l10n.questsFilterActivities,
                  'DAILY_QUEST': l10n.questsDaily,
                },
                _types,
                initiallyExpanded: true,
              ),
              _section(l10n.questsFilterAge, <QuestRange, String>{
                (min: 6, max: 9): l10n.questsFilterAgeRange('6–9'),
                (min: 10, max: 13): l10n.questsFilterAgeRange('10–13'),
                (min: 14, max: 17): l10n.questsFilterAgeRange('14–17'),
                (min: 18, max: null): l10n.questsFilterAgeRange('18+'),
              }, _ages),
              _section(l10n.questsFilterTime, <QuestRange, String>{
                (min: 0, max: 15): l10n.questsFilterUpTo15,
                (min: 16, max: 30): '16–30 min',
                (min: 31, max: 60): '31–60 min',
                (min: 61, max: null): l10n.questsFilterOver60,
              }, _minutes),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            onPressed: () => widget.onApply(
              QuestFilters(
                categories: Set.unmodifiable(_categories),
                types: Set.unmodifiable(_types),
                ages: Set.unmodifiable(_ages),
                minutes: Set.unmodifiable(_minutes),
              ),
            ),
            child: Text(l10n.questsFilterApply),
          ),
        ),
      ],
    );
  }

  Widget _section<T>(
    String title,
    Map<T, String> options,
    Set<T> selected, {
    bool initiallyExpanded = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(title),
        initiallyExpanded: initiallyExpanded,
        children: [
          for (final option in options.entries)
            CheckboxListTile(
              title: Text(
                option.value[0].toUpperCase() + option.value.substring(1),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: selected.contains(option.key),
              onChanged: (checked) => setState(() {
                if (checked == true) {
                  selected.add(option.key);
                } else {
                  selected.remove(option.key);
                }
              }),
            ),
        ],
      ),
    );
  }
}
