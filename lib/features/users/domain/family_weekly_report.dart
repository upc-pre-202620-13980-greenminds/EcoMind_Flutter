class FamilyWeeklyReport {
  final String familyName;
  final int completedQuests;
  final int totalQuests;
  final int achievementsEarned;

  const new({
    required this.familyName,
    required this.completedQuests,
    required this.totalQuests,
    required this.achievementsEarned,
  });

  // HU-021: without a completed quest in the week there is no report
  bool get hasData => completedQuests > 0;

  // Share of the quests completed, from 0 to 1, for the progress bar
  double get progress => totalQuests == 0 ? 0 : completedQuests / totalQuests;
}
