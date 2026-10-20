import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../provider/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_drawer.dart';
import '../widgets/add_edit_product_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // BARCODE SCAN / SUBMIT LOGIC
  void _handleBarcodeOrSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;

    final productProvider = context.read<ProductProvider>();
    final cartProvider = context.read<CartProvider>();

    try {
      // Direct barcode match search
      final scannedProduct = productProvider.products.firstWhere(
        (p) => p.barcode != null && p.barcode!.trim() == query,
      );

      // Cart me add karein
      cartProvider.addToCart(scannedProduct);

      // Notification display
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${scannedProduct.name} to Cart!'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );

      // Clear search and refocus for next scan
      _searchController.clear();
      productProvider.searchProducts('');
      _searchFocusNode.requestFocus();
    } catch (_) {
      // Agar match na mile to normal text search hone dein
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      endDrawer: const CartDrawer(),
      appBar: AppBar(
        title: const Text('Retail POS Dashboard'),
        actions: [
          // ADD PRODUCT BUTTON
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddEditProductDialog(),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: const Text('Add Product', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),

          // CART ICON WITH BADGE
          Builder(
            builder: (innerContext) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, size: 28),
                    onPressed: () {
                      Scaffold.of(innerContext).openEndDrawer();
                    },
                  ),
                  if (cartProvider.items.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartProvider.items.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          // BARCODE / SEARCH INPUT
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              onChanged: (value) {
                context.read<ProductProvider>().searchProducts(value);
              },
              onSubmitted: _handleBarcodeOrSearch, // Barcode scanner enter press hone par chalega
              decoration: InputDecoration(
                hintText: 'Scan Barcode or Search by Product Name...',
                prefixIcon: const Icon(Icons.qr_code_scanner),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductProvider>().searchProducts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),

          // PRODUCTS GRID VIEW
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Server Error: ${provider.errorMessage}'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => provider.fetchProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.products.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.products.length,
                  itemBuilder: (context, index) {
                    final product = provider.products[index];
                    return ProductCard(
                      product: product,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}