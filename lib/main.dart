import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_pos/service_locator.dart';
import 'package:flutter_pos/presentation/provider/product_provider.dart';
import 'package:flutter_pos/presentation/provider/cart_provider.dart';
import 'package:flutter_pos/presentation/provider/order_provider.dart';
import 'package:flutter_pos/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<ProductProvider>()..fetchProducts()..fetchCategories(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<CartProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<OrderProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'Retail POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}