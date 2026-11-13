import 'package:ecomind_parents/features/users/domain/commitment_repository.dart';
import 'package:ecomind_parents/features/users/domain/personal_commitment.dart';

class SaveCommitmentUseCase {
  final CommitmentRepository repository;

  const new({required this.repository});

  // The ViewModel checks the rule first; it is checked again here, as in the student app.
  // Returns the saved text, without the spaces at the start and at the end.
  Future<String> execute(String text) async {
    final trimmed = text.trim();
    if (!PersonalCommitment.isValid(trimmed)) {
      throw ArgumentError(
        'The commitment must have 1 to ${PersonalCommitment.maxLength} characters',
      );
    }
    await repository.saveCommitment(trimmed);
    return trimmed;
  }
}
