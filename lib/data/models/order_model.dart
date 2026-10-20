import '../../domain/entities/order.dart';
import 'product_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.items,
    required super.totalAmount,
    required super.paymentMethod,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      items: (json['line_items'] as List? ?? []).map((item) {
        return OrderItem(
          product: ProductModel.fromJson(item),
          quantity: item['quantity'] ?? 1,
        );
      }).toList(),
      totalAmount: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method_title'] ?? 'Cash',
      createdAt: DateTime.tryParse(json['date_created'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_method': paymentMethod.toLowerCase(),
      'payment_method_title': paymentMethod,
      'set_paid': true,
      'line_items': items.map((item) {
        return {
          'product_id': item.product.id,
          'quantity': item.quantity,
        };
      }).toList(),
    };
  }
}