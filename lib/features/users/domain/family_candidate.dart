import 'package:ecomind_parents/features/iam/domain/social_role.dart';

// Accepted friend who does not belong to any family yet
class FamilyCandidate {
  final int userId;
  final String name;
  final SocialRole socialRole;

  const new({
    required this.userId,
    required this.name,
    required this.socialRole,
  });
}
