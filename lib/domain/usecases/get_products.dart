import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/pos_repository.dart';

class GetProducts {
  final POSRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}