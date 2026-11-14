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
  Future<void> signOut(Session session);

  // The backend answers the same way whether or not the email has an account.
  // languageTag, when given, asks for the email in that language.
  Future<void> requestPasswordRecovery(String email, {String? languageTag});
  Future<void> confirmPasswordRecovery(
    String token,
    String newPassword, {
    String? confirmationId,
  });
}
