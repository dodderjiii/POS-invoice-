import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final double price; // Final Selling Price
  final String? image;
  final int? categoryId;
  final String stockStatus;
  
  // Extra Fields for Calculation & Display
  final String? categoryName;
  final double? costPrice;
  final double? profit;
  final double? tax;
  final String? barcode; // New Field Added

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    this.categoryId,
    this.stockStatus = 'instock',
    this.categoryName,
    this.costPrice,
    this.profit,
    this.tax,
    this.barcode,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        image,
        categoryId,
        stockStatus,
        categoryName,
        costPrice,
        profit,
        tax,
        barcode,
      ];
}