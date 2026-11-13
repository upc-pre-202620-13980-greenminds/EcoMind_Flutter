// Only the part of the achievement award that the weekly report and the medals need
class AchievementAwardDto {
  final String id;
  final String awardedAt;
  final String? achievementId;
  // INDIVIDUAL, FAMILY or COMMUNITY
  final String? scope;
  // Account that earned it; null for the awards of a group
  final int? beneficiaryId;

  const new({
    required this.id,
    required this.awardedAt,
    this.achievementId,
    this.scope,
    this.beneficiaryId,
  });

  factory AchievementAwardDto.fromJson(Map<String, dynamic> json) {
    return AchievementAwardDto(
      id: json['id'],
      awardedAt: json['awardedAt'],
      achievementId: json['achievementId'],
      scope: json['scope'],
      beneficiaryId: json['beneficiaryId'],
    );
  }
}
