import 'package:flutter/material.dart';

class InvoiceDialog extends StatelessWidget {
  final List<dynamic> cartItems;
  final double subtotal;
  final double total;
  final VoidCallback onFinishSale;

  const InvoiceDialog({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.total,
    required this.onFinishSale,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final invoiceNo = 'INV-${now.millisecondsSinceEpoch.toString().substring(5)}';
    final formattedDate = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // STORE HEADER
              const Text(
                'RETAIL POS STORE',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text('Main Market, Sector 1 | Ph: 0300-1234567',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
              const Divider(thickness: 1.5, height: 24),

              // INVOICE META INFO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invoice #: $invoiceNo',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(formattedDate,
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const Divider(),

              // ITEMS TABLE HEADER
              const Row(
                children: [
                  Expanded(flex: 3, child: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  Expanded(flex: 1, child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  Expanded(flex: 2, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                ],
              ),
              const SizedBox(height: 8),

              // ITEMS LIST
              ...cartItems.map((item) {
                final product = (item as dynamic).product;
                final quantity = (item as dynamic).quantity;
                final price = product?.price ?? 0.0;
                final name = product?.name ?? 'Item';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(name,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('$quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Rs. ${(price * quantity).toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const Divider(thickness: 1.5, height: 24),

              // TOTAL CALCULATIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:', style: TextStyle(fontSize: 13)),
                  Text('Rs. ${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('GRAND TOTAL:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    'Rs. ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
              const Divider(thickness: 1.5, height: 24),

              const Text('Thank you for shopping with us!',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            onFinishSale();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sale completed & Invoice Printed!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          icon: const Icon(Icons.print, color: Colors.white, size: 18),
          label: const Text('Print & Finish', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}