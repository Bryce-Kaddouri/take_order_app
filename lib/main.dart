import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:take_order_app/src/core/helper/route_helper.dart';
import 'package:take_order_app/src/features/auth/business/repository/auth_repository.dart';
import 'package:take_order_app/src/features/auth/business/usecase/auth_get_user_usecase.dart';
import 'package:take_order_app/src/features/auth/business/usecase/auth_is_looged_in_usecase.dart';
import 'package:take_order_app/src/features/auth/business/usecase/auth_login_usecase.dart';
import 'package:take_order_app/src/features/auth/business/usecase/auth_logout_usecase.dart';
import 'package:take_order_app/src/features/auth/business/usecase/auth_on_auth_change_usecase.dart';
import 'package:take_order_app/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:take_order_app/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:take_order_app/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:take_order_app/src/features/customer/business/repository/customer_repository.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_add_customer_usecase.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_get_customer_by_id_usecase.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_get_customers_usecase.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_update_customer_usecase.dart';
import 'package:take_order_app/src/features/customer/data/datasource/customer_datasource.dart';
import 'package:take_order_app/src/features/customer/data/repository/customer_repository_impl.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:take_order_app/src/features/order/business/repository/order_repository.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_get_orders_by_customer_id_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_place_order_usecase.dart';
import 'package:take_order_app/src/features/order/data/datasource/order_datasource.dart';
import 'package:take_order_app/src/features/order/data/repository/order_repository_impl.dart';
import 'package:take_order_app/src/features/order/presentation/provider/order_provider.dart';
import 'package:take_order_app/src/features/product/business/repository/product_repository.dart';
import 'package:take_order_app/src/features/product/business/usecase/product_get_product_by_id_usecase.dart';
import 'package:take_order_app/src/features/product/business/usecase/product_get_products_usecase.dart';
import 'package:take_order_app/src/features/product/business/usecase/product_get_signed_url_usecase.dart';
import 'package:take_order_app/src/features/product/data/datasource/product_datasource.dart';
import 'package:take_order_app/src/features/product/data/repository/product_repository_impl.dart';
import 'package:take_order_app/src/features/product/presentation/provider/product_provider.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://qlhzemdpzbonyqdecfxn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsaHplbWRwemJvbnlxZGVjZnhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4ODY4MDYsImV4cCI6MjAyMDQ2MjgwNn0.lcUJMI3dvMDT7LaO7MiudIkdxAZOZwF_hNtkQtF3OC8',
  );
  AuthRepository authRepository =
      AuthRepositoryImpl(dataSource: AuthDataSource());
  CustomerRepository customerRepository =
      CustomerRepositoryImpl(dataSource: CustomerDataSource());
  ProductRepository productRepository =
      ProductRepositoryImpl(dataSource: ProductDataSource());
  OrderRepository orderRepository =
      OrderRepositoryImpl(orderDataSource: OrderDataSource());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(
            productGetProductsUseCase:
                ProductGetProductsUseCase(productRepository: productRepository),
            productGetProductByIdUseCase: ProductGetProductByIdUseCase(
                productRepository: productRepository),
            productGetSignedUrlUseCase: ProductGetSignedUrlUseCase(
                productRepository: productRepository),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authLoginUseCase: AuthLoginUseCase(authRepository: authRepository),
            authLogoutUseCase:
                AuthLogoutUseCase(authRepository: authRepository),
            authGetUserUseCase:
                AuthGetUserUseCase(authRepository: authRepository),
            authIsLoggedInUseCase:
                AuthIsLoggedInUseCase(authRepository: authRepository),
            authOnAuthChangeUseCase:
                AuthOnAuthOnAuthChangeUseCase(authRepository: authRepository),
          ),
        ),
        ChangeNotifierProvider<CustomerProvider>(
          create: (context) => CustomerProvider(
            customerGetCustomersUseCase: CustomerGetCustomersUseCase(
                customerRepository: customerRepository),
            customerGetCustomersByIdUseCase: CustomerGetCustomerByIdUseCase(
                customerRepository: customerRepository),
            customerAddCustomerUseCase: CustomerAddCustomerUseCase(
                customerRepository: customerRepository),
            customerUpdateCustomerUseCase: CustomerUpdateCustomerUseCase(
                customerRepository: customerRepository),
          ),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(
            orderGetOrdersByDateUseCase:
                OrderGetOrdersByDateUseCase(orderRepository: orderRepository),
            orderGetOrdersByCustomerIdUseCase:
                OrderGetOrdersByCustomerIdUseCase(
                    orderRepository: orderRepository),
            orderPlaceOrderUseCase:
                OrderPlaceOrderUseCase(orderRepository: orderRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      debugShowCheckedModeBanner: false,

      routerDelegate: RouterHelper().getRouter(context).routerDelegate,
      routeInformationParser: RouterHelper().getRouter(context).routeInformationParser,
      routeInformationProvider: RouterHelper().getRouter(context).routeInformationProvider,

      title: 'Flutter Demo',
      theme: FluentThemeData.light(),
      darkTheme: FluentThemeData.dark(),
      /*home: const OrderScreen(),*/
    );
  }
}
