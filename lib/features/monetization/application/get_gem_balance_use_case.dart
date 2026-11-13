import 'package:ecomind_parents/features/monetization/domain/monetization_repository.dart';

class GetGemBalanceUseCase {
  final MonetizationRepository repository;
  const GetGemBalanceUseCase({required this.repository});
  Future<int> execute() => repository.getGemBalance();
}
