import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    super.image,
    super.categoryId,
    super.stockStatus,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0]['src']
          : null,
      stockStatus: json['stock_status'] ?? 'instock',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock_status': stockStatus,
    };
  }
}