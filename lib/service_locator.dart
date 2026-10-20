import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_pos/data/datasources/woocommerce_api.dart';
import 'package:flutter_pos/data/repositories/pos_repository_impl.dart';
import 'package:flutter_pos/domain/repositories/pos_repository.dart';

import 'package:flutter_pos/domain/usecases/get_products.dart';
import 'package:flutter_pos/domain/usecases/get_categories.dart';
import 'package:flutter_pos/domain/usecases/create_order.dart';

import 'package:flutter_pos/presentation/provider/product_provider.dart';
import 'package:flutter_pos/presentation/provider/cart_provider.dart';
import 'package:flutter_pos/presentation/provider/order_provider.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  getIt.registerLazySingleton(() => http.Client());

  // Data Sources
  getIt.registerLazySingleton<WooCommerceAPI>(
    () => WooCommerceAPIImpl(client: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<POSRepository>(
    () => POSRepositoryImpl(api: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => GetCategories(getIt()));
  getIt.registerLazySingleton(() => CreateOrder(getIt()));

  // Providers
  getIt.registerFactory(
    () => ProductProvider(
      getProductsUseCase: getIt(),
      getCategoriesUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => CartProvider(),
  );

  getIt.registerFactory(
    () => OrderProvider(
      createOrderUseCase: getIt(),
    ),
  );
}