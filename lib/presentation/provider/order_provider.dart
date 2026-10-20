import 'package:flutter/material.dart';
import 'package:flutter_pos/domain/entities/order.dart';
import 'package:flutter_pos/domain/usecases/create_order.dart';

class OrderProvider extends ChangeNotifier {
  final CreateOrder createOrderUseCase;

  OrderProvider({required this.createOrderUseCase});

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> placeOrder(Order order) async {
    _isLoading = true;
    notifyListeners();

    final result = await createOrderUseCase(order);
    bool success = false;

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        success = false;
      },
      (createdOrder) {
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}