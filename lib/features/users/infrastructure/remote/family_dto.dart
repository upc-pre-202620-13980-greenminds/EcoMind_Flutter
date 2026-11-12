class FamilyMemberDto {
  // Id of the membership
  final int id;
  final int familyId;
  final int userId;
  final String familyRole;

  const new({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.familyRole,
  });

  factory FamilyMemberDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberDto(
      id: json['id'],
      familyId: json['familyId'],
      userId: json['userId'],
      familyRole: json['familyRole'],
    );
  }
}

class FamilyDto {
  final int id;
  final String name;
  final String commitment;
  final List<FamilyMemberDto> members;

  const new({
    required this.id,
    required this.name,
    required this.commitment,
    required this.members,
  });

  factory FamilyDto.fromJson(Map<String, dynamic> json) {
    final List members = json['members'] ?? [];
    return FamilyDto(
      id: json['id'],
      name: json['name'],
      commitment: json['commitment'],
      members: members.map((e) => FamilyMemberDto.fromJson(e)).toList(),
    );
  }
}
