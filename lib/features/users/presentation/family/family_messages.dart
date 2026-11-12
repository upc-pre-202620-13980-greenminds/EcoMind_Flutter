import 'package:ecomind_parents/features/users/domain/family_member.dart';
import 'package:ecomind_parents/features/users/domain/family_role.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';

extension FamilyRoleText on FamilyRole {
  String text(AppLocalizations l10n) {
    return switch (this) {
      FamilyRole.parent => l10n.familyRoleParent,
      FamilyRole.child => l10n.familyRoleChild,
    };
  }
}

extension FamilyMemberSubtitle on FamilyMember {
  // "Parent · family manager" for the parent who is signed in, the role for the rest
  String subtitle(AppLocalizations l10n) {
    return isCurrentUser ? l10n.familyManagerRole : role.text(l10n);
  }
}

extension UsersErrorText on UsersError {
  String text(AppLocalizations l10n) {
    return switch (this) {
      UsersError.creatorNotParent => l10n.errorCreatorNotParent,
      UsersError.membershipConflict => l10n.errorAlreadyInFamily,
      UsersError.familyFull => l10n.errorFamilyFull,
      UsersError.connection => l10n.errorConnection,
      _ => l10n.errorUnknown,
    };
  }
}
