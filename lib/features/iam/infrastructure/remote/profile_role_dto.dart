// Only the part of GET /api/v1/user/{id} that Sign in needs
class ProfileRoleDto {
  final int id;
  final String socialRole;

  const new({required this.id, required this.socialRole});

  factory ProfileRoleDto.fromJson(Map<String, dynamic> json) {
    return ProfileRoleDto(id: json['id'], socialRole: json['socialRole']);
  }
}
