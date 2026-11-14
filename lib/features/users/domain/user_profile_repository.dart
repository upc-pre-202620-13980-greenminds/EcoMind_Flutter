import 'package:ecomind_parents/features/users/domain/user_profile.dart';

// Every method throws a UsersException when the request fails
abstract class UserProfileRepository {
  // Profile of the parent who is signed in
  Future<UserProfile> getCurrentProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
}
