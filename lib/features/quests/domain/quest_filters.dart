import 'package:ecomind_parents/features/quests/domain/quest.dart';

typedef QuestRange = ({int min, int? max});

class QuestFilters {
  const new({
    this.categories = const {},
    this.types = const {},
    this.ages = const {},
    this.minutes = const {},
  });

  final Set<String> categories;
  final Set<String> types;
  final Set<QuestRange> ages;
  final Set<QuestRange> minutes;

  bool get isActive =>
      categories.isNotEmpty ||
      types.isNotEmpty ||
      ages.isNotEmpty ||
      minutes.isNotEmpty;

  bool matches(Quest quest) =>
      (categories.isEmpty || categories.contains(quest.category)) &&
      (types.isEmpty || types.contains(quest.type)) &&
      (quest.age == null || _matches(ages, quest.age)) &&
      _matches(minutes, quest.minutes);

  bool _matches(Set<QuestRange> ranges, int? value) =>
      ranges.isEmpty ||
      (value != null &&
          ranges.any((range) {
            final max = range.max;
            return value >= range.min && (max == null || value <= max);
          }));
}
