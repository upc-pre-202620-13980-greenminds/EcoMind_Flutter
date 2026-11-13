class Quest {
  const new({
    required this.id,
    required this.title,
    required this.description,
    required this.theme,
    required this.type,
    this.age,
    this.minutes,
    this.category,
    this.imageUrl,
    this.ecopoints = 0,
    this.gems = 0,
  });

  final int id;
  final String title;
  final String description;
  final String theme;
  final String type;
  final int? age;
  final int? minutes;
  final String? category;
  final String? imageUrl;
  final int ecopoints;
  final int gems;

  bool get isDaily => type == 'DAILY_QUEST';

  bool get canStart =>
      type == 'ACTIVITIES' || type == 'DAILY_QUEST' || type == 'COLLABORATIVE';
}

class QuestAssignment {
  const new({
    required this.id,
    required this.questId,
    required this.status,
    this.progress = 0,
    this.collaborativeSessionId,
    this.endDate,
  });

  final int id;
  final int questId;
  final String status;
  final double progress;
  final int? collaborativeSessionId;
  final DateTime? endDate;

  bool get isPending =>
      status == 'IN_PROGRESS' || status == 'READY_TO_COMPLETE';
}

typedef PendingQuest = ({Quest quest, QuestAssignment assignment});

typedef QuestProgressEntry = ({Quest? quest, QuestAssignment assignment});

class QuestActivity {
  const new({
    required this.description,
    required this.type,
    required this.assignmentId,
    required this.isComplete,
    required this.minCharacters,
    this.response,
  });

  final String description;
  final String type;
  final int? assignmentId;
  final bool isComplete;
  final int minCharacters;
  final String? response;
}

typedef QuestDetails = ({
  QuestAssignment? assignment,
  List<QuestActivity> activities,
});
