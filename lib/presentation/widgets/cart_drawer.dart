import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import 'invoice_dialog.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    // Dynamic fallback for total price if provider uses different name
    double subtotal = 0.0;
    try {
      subtotal = (cartProvider as dynamic).totalPrice;
    } catch (_) {
      try {
        subtotal = (cartProvider as dynamic).totalAmount;
      } catch (_) {
        subtotal = cartProvider.items.fold(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        );
      }
    }

    return Drawer(
      width: 380,
      child: Column(
        children: [
          AppBar(
            title: const Text('Shopping Cart'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          Expanded(
            child: cartProvider.items.isEmpty
                ? const Center(
                    child: Text('Your cart is empty',
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartProvider.items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return ListTile(
                        title: Text(item.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Rs. ${item.product.price.toStringAsFixed(2)} x ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () {
                                try {
                                  (cartProvider as dynamic).decreaseQuantity(item.product.id);
                                } catch (_) {
                                  try {
                                    (cartProvider as dynamic).removeFromCart(item.product.id);
                                  } catch (_) {
                                    (cartProvider as dynamic).removeSingleItem(item.product.id);
                                  }
                                }
                              },
                            ),
                            Text('${item.quantity}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.green),
                              onPressed: () =>
                                  cartProvider.addToCart(item.product),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      'Rs. ${subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    onPressed: cartProvider.items.isEmpty
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (_) => InvoiceDialog(
                                cartItems: cartProvider.items,
                                subtotal: subtotal,
                                total: subtotal,
                                onFinishSale: () {
                                  cartProvider.clearCart();
                                },
                              ),
                            );
                          },
                    child: const Text('Checkout / Print Receipt',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}