class AppConstants {
  static const String appName = ' RetailPOS';
  static const String appVersion = '1.0.0';

  // Tax
  static const double taxRate = 0.07; // 7% tax rate
  // pagination
  static const int productsPerPage = 20;
  static const int categoriesPerPage = 10;

  // UI constants
  static const double gridCrossAxisSpacing = 15.0;
  static const double gridMainAxisSpacing = 15.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;

  // colors
  static const int primaryColor = 0xFF6200EE;
  static const int secondaryColor = 0xFF03DAC6;
  static const int errorColor = 0xFFB00020;
  static const int successColor = 0xFF4CAF50;

  //payment methods
  static const List<Map<String, String>> paymentMethods = [
    {'name': 'Cash', 'emojji': '💵'},
    {'name': 'Credit Card', 'emojji': '💳'},
    {'name': 'Mobile Payment', 'emojji': '📱'},
    {'name': 'Gift Card', 'emojji': '🎁'},
  ];

  // order status 
  static const String orderStatusPending = 'pending';
  static const String orderStatusCompleted = 'completed';
  static const String orderStatusProcessing = 'processing';

  //  stock status
  static const String stockStatusInStock = 'instock';
  static const String stockStatusOutOfStock = 'outofstock';
  static const String stockStatusOnBackOrder = 'onbackorder';

}



