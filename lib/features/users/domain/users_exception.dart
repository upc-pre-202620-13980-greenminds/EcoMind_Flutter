enum UsersError {
  sessionExpired,
  forbidden,
  notFound,
  creatorNotParent,
  membershipConflict,
  familyFull,
  parentSelfRemoval,
  connection,
  unknown,
}

class UsersException implements Exception {
  final UsersError error;

  const new(this.error);

  @override
  String toString() => 'UsersException($error)';
}
