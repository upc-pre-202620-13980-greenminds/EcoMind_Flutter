import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';

// Every method throws an AuthException when the request fails
abstract class AuthRepository {
  Future<Session> signIn(String email, String password);
  Future<SocialRole> getSocialRole(Session session);
  Future<void> signUp(
    String name,
    String email,
    String password,
    SocialRole role,
  );
  Future<void> verifyEmail(String email, String code);
}
