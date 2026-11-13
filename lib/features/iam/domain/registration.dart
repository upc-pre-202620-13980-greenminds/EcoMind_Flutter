import 'package:ecomind_parents/features/iam/domain/social_role.dart';

// Data typed in Sign up; Verify email needs it again to resend the code and to sign in
class Registration {
  final String name;
  final String email;
  final String password;
  final SocialRole role;

  const new({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}
