class UserProfileDto {
  final int id;
  final String name;
  final String socialRole;
  final int streak;
  final String? lastStreakDate;
  final int ecopoints;
  final int gemBalance;
  // Image of the avatar equipped in Store; null when the user has none
  final String? avatarImageReference;

  const new({
    required this.id,
    required this.name,
    required this.socialRole,
    required this.streak,
    required this.lastStreakDate,
    required this.ecopoints,
    required this.gemBalance,
    this.avatarImageReference,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'],
      name: json['name'],
      socialRole: json['socialRole'],
      streak: json['streak'],
      lastStreakDate: json['lastStreakDate'],
      ecopoints: json['ecopoints'],
      gemBalance: json['gemBalance'],
      avatarImageReference: json['avatarImageReference'],
    );
  }

  // Body of PUT /api/v1/user/{id}
  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'streak': streak,
      'lastStreakDate': lastStreakDate,
      'ecopoints': ecopoints,
      'gemBalance': gemBalance,
    };
  }
}
