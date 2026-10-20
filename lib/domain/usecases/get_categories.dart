import 'package:fpdart/fpdart.dart';
import '../../core/errors/failure.dart';
import '../entities/category.dart';
import '../repositories/pos_repository.dart';

class GetCategories {
  final POSRepository repository;

  GetCategories(this.repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}