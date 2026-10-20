import 'package:fpdart/fpdart.dart' hide Order; // <--- hide Order add kiya hai
import '../../core/errors/failure.dart';
import '../entities/order.dart';
import '../repositories/pos_repository.dart';

class CreateOrder {
  final POSRepository repository;

  CreateOrder(this.repository);

  Future<Either<Failure, Order>> call(Order order) async {
    return await repository.createOrder(order);
  }
}