import 'dart:io';
import 'package:fpdart/fpdart.dart' hide Order;

import 'package:flutter_pos/core/errors/failure.dart';
import 'package:flutter_pos/domain/entities/product.dart';
import 'package:flutter_pos/domain/entities/category.dart';
import 'package:flutter_pos/domain/entities/order.dart';
import 'package:flutter_pos/domain/repositories/pos_repository.dart';

import 'package:flutter_pos/data/datasources/woocommerce_api.dart';
import 'package:flutter_pos/data/models/order_model.dart';

class POSRepositoryImpl implements POSRepository {
  final WooCommerceAPI api;

  POSRepositoryImpl({required this.api});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await api.getProducts();
      return Right(products);
    } on SocketException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure('Server Error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await api.getCategories();
      return Right(categories);
    } on SocketException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure('Server Error: $e'));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrder(Order order) async {
    try {
      final orderModel = OrderModel(
        id: order.id,
        items: order.items,
        totalAmount: order.totalAmount,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
      );
      final createdOrder = await api.createOrder(orderModel);
      return Right(createdOrder);
    } on SocketException {
      return const Left(NetworkFailure('No Internet Connection'));
    } catch (e) {
      return Left(ServerFailure('Server Error: $e'));
    }
  }
}