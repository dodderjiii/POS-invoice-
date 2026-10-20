import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../presentation/provider/cart_provider.dart';

class InvoicePrinter {
  
  static Future<void> printReceipt({
    required List<CartItem> items,
    required double totalAmount,
  }) async {
    try {
      final pdf = pw.Document();

      final font = await PdfGoogleFonts.robotoRegular();
      final fontBold = await PdfGoogleFonts.robotoBold();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          margin: const pw.EdgeInsets.all(10),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'RETAIL POS STORE',
                    style: pw.TextStyle(font: fontBold, fontSize: 14),
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Center(
                  child: pw.Text(
                    'Date: ${DateTime.now().toString().split('.')[0]}',
                    style: pw.TextStyle(font: font, fontSize: 8),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Divider(),

                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text('Item', style: pw.TextStyle(font: fontBold, fontSize: 9)),
                    ),
                    pw.Text('Qty', style: pw.TextStyle(font: fontBold, fontSize: 9)),
                    pw.SizedBox(width: 8),
                    pw.Text('Total', style: pw.TextStyle(font: fontBold, fontSize: 9)),
                  ],
                ),
                pw.Divider(),

                // Item Rows
                ...items.map((item) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Text(item.product.name, style: pw.TextStyle(font: font, fontSize: 9)),
                        ),
                        pw.Text('x${item.quantity}', style: pw.TextStyle(font: font, fontSize: 9)),
                        pw.SizedBox(width: 8),
                        pw.Text(
                          'Rs. ${(item.product.price * item.quantity).toStringAsFixed(0)}',
                          style: pw.TextStyle(font: font, fontSize: 9),
                        ),
                      ],
                    ),
                  );
                }),

                pw.Divider(),
                pw.SizedBox(height: 4),

                // Grand Total
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('GRAND TOTAL:', style: pw.TextStyle(font: fontBold, fontSize: 10)),
                    pw.Text(
                      'Rs. ${totalAmount.toStringAsFixed(0)}',
                      style: pw.TextStyle(font: fontBold, fontSize: 10),
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text('Thank you for shopping!', style: pw.TextStyle(font: font, fontSize: 8)),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => bytes,
      );
    } catch (e) {
      debugPrint('Print Error: $e');
    }
  }
}