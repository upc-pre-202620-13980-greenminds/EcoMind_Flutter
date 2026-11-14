import 'package:ecomind_parents/features/users/domain/family_member.dart';

class Family {
  // Business rule of Users: a family has at most 5 members
  static const int maxMembers = 5;

  final int id;
  final String name;
  final String commitment;
  final List<FamilyMember> members;

  const new({
    required this.id,
    required this.name,
    required this.commitment,
    required this.members,
  });

  bool get isFull => members.length >= maxMembers;

  // Members that the parent can manage: everyone except the parent who is signed in
  List<FamilyMember> get otherMembers =>
      members.where((member) => !member.isCurrentUser).toList();
}
