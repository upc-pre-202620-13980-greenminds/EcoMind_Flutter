import 'package:ecomind_parents/features/iam/domain/social_role.dart';

class UserProfile {
  final int id;
  final String name;
  final SocialRole socialRole;
  final int streak;
  final DateTime? lastStreakDate;
  final int ecopoints;
  final int gemBalance;

  const new({
    required this.id,
    required this.name,
    required this.socialRole,
    required this.streak,
    required this.lastStreakDate,
    required this.ecopoints,
    required this.gemBalance,
  });

  // Only the name can be edited by the parent; the rest comes from other contexts
  UserProfile withName(String newName) {
    return UserProfile(
      id: id,
      name: newName,
      socialRole: socialRole,
      streak: streak,
      lastStreakDate: lastStreakDate,
      ecopoints: ecopoints,
      gemBalance: gemBalance,
    );
  }
}
