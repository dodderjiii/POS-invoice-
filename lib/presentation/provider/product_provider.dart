import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_categories.dart';

class ProductProvider extends ChangeNotifier {
  final GetProducts getProductsUseCase;
  final GetCategories getCategoriesUseCase;

  ProductProvider({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
  });

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  List<Product> get products => _filteredProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Fetch Products from WooCommerce API
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getProductsUseCase();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (productList) {
        _allProducts = productList;
        _filteredProducts = List.from(_allProducts);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Categories Fetch
  Future<void> fetchCategories() async {
    await getCategoriesUseCase();
  }

  // Search Products
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // Add Product Manually
  void addProduct(Product product) {
    _allProducts.add(product);
    _filteredProducts = List.from(_allProducts);
    notifyListeners();
  }

  // Update Existing Product Price/Name
  void updateProduct(int id, String newName, double newPrice) {
    final index = _allProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final updatedProduct = Product(
        id: id,
        name: newName,
        price: newPrice,
      );
      _allProducts[index] = updatedProduct;

      final filterIndex = _filteredProducts.indexWhere((p) => p.id == id);
      if (filterIndex != -1) {
        _filteredProducts[filterIndex] = updatedProduct;
      }

      notifyListeners();
    }
  }

  // Delete Product Method (YEH ADD KIYA HAI)
  void deleteProduct(int id) {
    _allProducts.removeWhere((p) => p.id == id);
    _filteredProducts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}