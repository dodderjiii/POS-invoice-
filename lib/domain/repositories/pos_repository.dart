import 'package:fpdart/fpdart.dart' hide Order;
import '../../core/errors/failure.dart';
import '../entities/product.dart';
import '../entities/category.dart';
import '../entities/order.dart';

abstract class POSRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Order>> createOrder(Order order);
}