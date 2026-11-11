enum UsersError { sessionExpired, forbidden, notFound, connection, unknown }

class UsersException implements Exception {
  final UsersError error;

  const new(this.error);

  @override
  String toString() => 'UsersException($error)';
}
