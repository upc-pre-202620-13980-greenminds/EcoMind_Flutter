import 'package:ecomind_parents/features/users/domain/commitment_repository.dart';

class GetCommitmentUseCase {
  final CommitmentRepository repository;

  const new({required this.repository});

  Future<String?> execute() {
    return repository.getCommitment();
  }
}
