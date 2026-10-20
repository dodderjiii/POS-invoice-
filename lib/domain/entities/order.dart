import 'package:equatable/equatable.dart';
import 'product.dart';

class OrderItem extends Equatable {
  final Product product;
  final int quantity;

  const OrderItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}

class Order extends Equatable {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final String paymentMethod;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, items, totalAmount, paymentMethod, createdAt];
}