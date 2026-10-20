import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/product.dart';
import '../provider/product_provider.dart';

class AddEditProductDialog extends StatefulWidget {
  final Product? productToEdit;

  const AddEditProductDialog({super.key, this.productToEdit});

  @override
  State<AddEditProductDialog> createState() => _AddEditProductDialogState();
}

class _AddEditProductDialogState extends State<AddEditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _costPriceController;
  late TextEditingController _barcodeController;
  late TextEditingController _profitController;
  late TextEditingController _taxController;

  double _calculatedSellingPrice = 0.0;

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;

    _nameController = TextEditingController(text: p?.name ?? '');
    _costPriceController = TextEditingController(text: p?.costPrice?.toString() ?? '');
    _barcodeController = TextEditingController(text: p?.barcode ?? '');
    _profitController = TextEditingController(text: p?.profit?.toString() ?? '');
    _taxController = TextEditingController(text: p?.tax?.toString() ?? '');

    _calculatedSellingPrice = p?.price ?? 0.0;
  }

  void _calculatePrice() {
    final cost = double.tryParse(_costPriceController.text.trim()) ?? 0.0;
    final profit = double.tryParse(_profitController.text.trim()) ?? 0.0;
    final taxPercent = double.tryParse(_taxController.text.trim()) ?? 0.0;

    final priceWithProfit = cost + profit;
    final taxAmount = (priceWithProfit * taxPercent) / 100;

    setState(() {
      _calculatedSellingPrice = priceWithProfit + taxAmount;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costPriceController.dispose();
    _barcodeController.dispose();
    _profitController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final rawName = _nameController.text.trim();
      final costPrice = double.tryParse(_costPriceController.text.trim()) ?? 0.0;
      final barcode = _barcodeController.text.trim();
      final profit = double.tryParse(_profitController.text.trim()) ?? 0.0;
      final tax = double.tryParse(_taxController.text.trim()) ?? 0.0;

      final finalPrice = _calculatedSellingPrice > 0 ? _calculatedSellingPrice : costPrice;

      final provider = context.read<ProductProvider>();

      if (widget.productToEdit != null) {
        provider.updateProduct(
          widget.productToEdit!.id,
          rawName,
          finalPrice,
        );
      } else {
        final newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          name: rawName,
          price: finalPrice,
          costPrice: costPrice,
          barcode: barcode,
          profit: profit,
          tax: tax,
        );
        provider.addProduct(newProduct);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'e.g. Sunsilk 200ml',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: 'Barcode Number',
                    hintText: 'e.g. 896400012345',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _costPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Actual Cost (Rs.)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculatePrice(),
                  validator: (val) => val == null || val.isEmpty ? 'Enter actual cost' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _profitController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Profit (Rs.)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculatePrice(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _taxController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Tax (%)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculatePrice(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Final Selling Price:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Rs. ${_calculatedSellingPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEditing ? Colors.orange : Colors.blue,
          ),
          onPressed: _saveProduct,
          child: Text(
            isEditing ? 'Update' : 'Save',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}