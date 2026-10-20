import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../provider/cart_provider.dart';
import '../provider/product_provider.dart';
import 'add_edit_product_dialog.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // FIX: product.category ki jagah product.categoryName use kiya hai
    final categoryText = product.categoryName ?? 'Item';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    categoryText,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange, size: 18),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddEditProductDialog(productToEdit: product),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.read<ProductProvider>().deleteProduct(product.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              // FIX: product.categoryName update kar diya hai
              '${product.categoryName != null ? '${product.categoryName} - ' : ''}${product.name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Rs. ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (product.costPrice != null)
              Text(
                'Cost: Rs. ${product.costPrice} | Tax: ${product.tax ?? 0}%',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<CartProvider>().addToCart(product);
                },
                icon: const Icon(Icons.add_shopping_cart, size: 16),
                label: const Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}