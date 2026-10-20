import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/order_model.dart';

abstract class WooCommerceAPI {
  Future<List<ProductModel>> getProducts();
  Future<List<CategoryModel>> getCategories();
  Future<OrderModel> createOrder(OrderModel order);
}

class WooCommerceAPIImpl implements WooCommerceAPI {
  final http.Client client;

  final String baseUrl = "https://myposstore.local/wp-json/wc/v3";
  final String consumerKey = "ck_0550920958398a8c356168a1ed440a9bab97b256";
  final String consumerSecret = "cs_8b9e6739e663f21e100ca0736e6c0308a404b0e0";

  WooCommerceAPIImpl({required this.client});

  // Basic Auth Header Generation
  Map<String, String> get _headers {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}';
    return {
      'Authorization': basicAuth,
      'Content-Type': 'application/json',
    };
  }

  @override
@override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(
      Uri.parse('$baseUrl/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/products/categories'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final response = await client.post(
      Uri.parse('$baseUrl/orders'),
      headers: _headers,
      body: json.encode(order.toJson()),
    );

    if (response.statusCode == 201) {
      return OrderModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create order');
    }
  }
}