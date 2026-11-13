class Community {
  const Community({
    required this.id,
    required this.name,
    required this.description,
    required this.locality,
    this.iconUrl,
  });

  final int id;
  final String name;
  final String description;
  final String locality;
  final String? iconUrl;
}

class CommunityEvent {
  const CommunityEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.availablePlaces,
    this.imageUrl,
  });

  final int id;
  final String name;
  final String description;
  final String location;
  final int availablePlaces;
  final String? imageUrl;
}

class CommunityGoal {
  const CommunityGoal({
    required this.title,
    required this.progress,
    required this.target,
  });

  final String title;
  final int progress;
  final int target;

  double get fraction =>
      target <= 0 ? 0 : (progress / target).clamp(0.0, 1.0).toDouble();
}

typedef CommunityDirectory = ({
  List<Community> communities,
  Set<int> membershipIds,
});
