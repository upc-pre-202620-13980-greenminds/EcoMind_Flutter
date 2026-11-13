// The backend has no route for the personal commitment, so it lives on the device
abstract class CommitmentRepository {
  // Null when the user has not written a commitment yet
  Future<String?> getCommitment();

  // Adds the commitment or replaces the one the user already had
  Future<void> saveCommitment(String text);
}
