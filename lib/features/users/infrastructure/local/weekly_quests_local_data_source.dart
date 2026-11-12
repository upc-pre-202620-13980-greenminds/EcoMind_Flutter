import 'package:ecomind_parents/features/users/domain/family.dart';

class WeeklyQuests {
  final int completed;
  final int total;

  const new({required this.completed, required this.total});
}

// The quests belong to the Quests context, which this application does not implement.
// Until it is connected, these sample values let the demo show both states of HU-021.
class WeeklyQuestsLocalDataSource {
  // Fixed sample for each member besides the parent
  static const int completedPerMember = 3;
  static const int totalPerMember = 5;

  WeeklyQuests getForFamily(Family family) {
    // Only the parent: there are no quests, so the report is empty (frame 54)
    final otherMembers = family.otherMembers.length;
    return WeeklyQuests(
      completed: otherMembers * completedPerMember,
      total: otherMembers * totalPerMember,
    );
  }

  // Used when the achievements cannot be read from the backend
  int sampleAchievements(Family family) => family.otherMembers.length;
}
