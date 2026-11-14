// Definition of an achievement of the catalog of Gamification; only the name is shown
class AchievementDto {
  final String id;
  final String name;

  const new({required this.id, required this.name});

  factory AchievementDto.fromJson(Map<String, dynamic> json) {
    return AchievementDto(id: json['id'], name: json['name']);
  }
}
