// Only the part of the achievement award that the weekly report needs
class AchievementAwardDto {
  final String id;
  final String awardedAt;

  const new({required this.id, required this.awardedAt});

  factory AchievementAwardDto.fromJson(Map<String, dynamic> json) {
    return AchievementAwardDto(id: json['id'], awardedAt: json['awardedAt']);
  }
}
