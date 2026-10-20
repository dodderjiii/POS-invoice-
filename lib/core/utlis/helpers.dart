import 'dart:convert';
import 'package:flutter/material.dart';

class Helpers {
  static String formatCurrency(double price, {String currencySymbol = '\$'}) {
    return '$currencySymbol${price.toStringAsFixed(2)}';
  }

  static double calculateTax(double amount, double taxRate) {
    return amount * taxRate;
  }

  static double calculateTotal(double subtotal, double tax) {
    return subtotal + tax;
  }

  static String generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD${timestamp.toString().substring(8)}';
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Map<String, dynamic>? parseJson(String jsonString) {
    try {
      return json.decode(jsonString);
    } catch (e) {
      return null;
    }
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}