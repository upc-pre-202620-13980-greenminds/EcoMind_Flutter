import 'package:ecomind_parents/features/monetization/domain/monetization_repository.dart';
import 'package:ecomind_parents/features/monetization/domain/store_catalog.dart';

class GetStoreCatalogUseCase {
  final MonetizationRepository repository;
  const GetStoreCatalogUseCase({required this.repository});
  Future<StoreCatalog> execute() => repository.getCatalog();
}
