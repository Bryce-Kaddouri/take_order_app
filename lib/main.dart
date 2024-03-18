/*
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
// #docregion AppLocalizationsImport
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// #enddocregion AppLocalizationsImport

// #docregion LocalizationDelegatesImport
import 'package:flutter_localizations/flutter_localizations.dart';
// import package to set path url startegy
import 'package:flutter_web_plugins/url_strategy.dart';
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
import 'package:take_order_app/src/features/order/business/usecase/order_get_order_by_id_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_get_orders_by_customer_id_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_place_order_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_update_order_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_update_to_collected_usecase.dart';
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
import 'package:take_order_app/src/features/profile/presentation/provider/profile_provider.dart';

Future<void> main() async {
  // set path url
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: '',
  );

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
*/
/*
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFsaHplbWRwemJvbnlxZGVjZnhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ4ODY4MDYsImV4cCI6MjAyMDQ2MjgwNn0.lcUJMI3dvMDT7LaO7MiudIkdxAZOZwF_hNtkQtF3OC8',
*/ /*

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
            orderGetOrdersByIdUseCase:
                OrderGetOrdersByIdUseCase(orderRepository: orderRepository),
            orderUpdateOrderUseCase:
                OrderUpdateOrderUseCase(orderRepository: orderRepository),
            orderUpdateToCollectedUseCase:
                OrderUpdateToCollectedUseCase(orderRepository: orderRepository),
          ),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileProvider>().getThemeMode();
  }
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return fluent.FluentApp.router(
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
      ],
      theme: fluent.FluentThemeData.light(),
      darkTheme: fluent.FluentThemeData.dark(),
      themeMode: context.watch<ProfileProvider>().themeMode == 'system'
          ? ThemeMode.system
          : context.watch<ProfileProvider>().themeMode == 'light'
              ? ThemeMode.light
              : ThemeMode.dark,
      // hide keyboard when tap outside
      debugShowCheckedModeBanner: false,
      */
/* routerDelegate: RouterHelper().getRouter(context).routerDelegate,
      routeInformationParser:
          RouterHelper().getRouter(context).routeInformationParser,
      routeInformationProvider:
          RouterHelper().getRouter(context).routeInformationProvider,*/ /*

      routerConfig: RouterHelper().getRouter(context),
      title: 'Flutter Demo',
    );
  }
}
*/

// #enddocregion LocalizationDelegatesImport

import 'package:fluent_ui/fluent_ui.dart';
// #docregion AppLocalizationsImport
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// #enddocregion AppLocalizationsImport

// #docregion LocalizationDelegatesImport
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
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
import 'package:take_order_app/src/features/order/business/usecase/order_get_order_by_id_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_get_orders_by_customer_id_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_get_orders_by_date_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_place_order_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_update_order_usecase.dart';
import 'package:take_order_app/src/features/order/business/usecase/order_update_to_collected_usecase.dart';
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
import 'package:take_order_app/src/features/profile/presentation/provider/profile_provider.dart';

Future<void> main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: '',
  );
  print('supabaseUrl: $supabaseUrl');
  print('supabaseAnnonKey: $supabaseAnnonKey');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnnonKey,
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
            orderGetOrdersByIdUseCase:
                OrderGetOrdersByIdUseCase(orderRepository: orderRepository),
            orderUpdateOrderUseCase:
                OrderUpdateOrderUseCase(orderRepository: orderRepository),
            orderUpdateToCollectedUseCase:
                OrderUpdateToCollectedUseCase(orderRepository: orderRepository),
          ),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    context.read<ProfileProvider>().getThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    // #docregion MaterialApp
    return FluentApp.router(
      title: 'Localizations Sample App',
      locale: context.watch<ProfileProvider>().languageCode == 'en'
          ? const Locale('en')
          : context.watch<ProfileProvider>().languageCode == 'es'
              ? const Locale('es')
              : const Locale('fr'),
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
      ],
      theme: FluentThemeData.light(),
      darkTheme: FluentThemeData.dark(),
      themeMode: context.watch<ProfileProvider>().themeMode == 'system'
          ? ThemeMode.system
          : context.watch<ProfileProvider>().themeMode == 'light'
              ? ThemeMode.light
              : ThemeMode.dark,
      // hide keyboard when tap outside
      debugShowCheckedModeBanner: false,

      routerConfig: RouterHelper().getRouter(context),
      /* home: MyHomePage(),*/
    );
    // #enddocregion MaterialApp
  }
}

class TranslationHelper {
  BuildContext context;

  TranslationHelper({required this.context});

  String getTranslation(String key) {
    Map<String, String> translations = {
      'helloWorld': AppLocalizations.of(context)!.helloWorld,
      'email': AppLocalizations.of(context)!.email,
      'password': AppLocalizations.of(context)!.password,
      'invalidEmailOrPassword':
          AppLocalizations.of(context)!.invalidEmailOrPassword,
      'signIn': AppLocalizations.of(context)!.signIn,
      'signOut': AppLocalizations.of(context)!.signOut,
      'confirmSignOut': AppLocalizations.of(context)!.confirmSignOut,
      'yes': AppLocalizations.of(context)!.yes,
      'no': AppLocalizations.of(context)!.no,
      'confirmCancel': AppLocalizations.of(context)!.confirmCancel,
      'error': AppLocalizations.of(context)!.error,
      'home': AppLocalizations.of(context)!.home,
      'orderList': AppLocalizations.of(context)!.orderList,
      'addOrder': AppLocalizations.of(context)!.addOrder,
      'trackOrders': AppLocalizations.of(context)!.trackOrders,
      'customerList': AppLocalizations.of(context)!.customerList,
      'addCustomer': AppLocalizations.of(context)!.addCustomer,
      'profile': AppLocalizations.of(context)!.profile,
      'settings': AppLocalizations.of(context)!.settings,
      'orders': AppLocalizations.of(context)!.orders,
      'totalAmount': AppLocalizations.of(context)!.totalAmount,
      'pending': AppLocalizations.of(context)!.pending,
      'inProgress': AppLocalizations.of(context)!.inProgress,
      'completed': AppLocalizations.of(context)!.completed,
      'collected': AppLocalizations.of(context)!.collected,
      'previous': AppLocalizations.of(context)!.previous,
      'next': AppLocalizations.of(context)!.next,
      'customerDetails': AppLocalizations.of(context)!.customerDetails,
      'selectCustomer': AppLocalizations.of(context)!.selectCustomer,
      'dateAndTime': AppLocalizations.of(context)!.dateAndTime,
      'pickDate': AppLocalizations.of(context)!.pickDate,
      'pickTime': AppLocalizations.of(context)!.pickTime,
      'fillOrder': AppLocalizations.of(context)!.fillOrder,
      'quantity': AppLocalizations.of(context)!.quantity,
      'editQuantity': AppLocalizations.of(context)!.editQuantity,
      'noItemAdded': AppLocalizations.of(context)!.noItemAdded,
      'pleaseAddItemFirst': AppLocalizations.of(context)!.pleaseAddItemFirst,
      'addItemCart': AppLocalizations.of(context)!.addItemCart,
      'confirm': AppLocalizations.of(context)!.confirm,
      'cancel': AppLocalizations.of(context)!.cancel,
      'paymentDetails': AppLocalizations.of(context)!.paymentDetails,
      'paymentAmount': AppLocalizations.of(context)!.paymentAmount,
      'note': AppLocalizations.of(context)!.note,
      'reviewOrder': AppLocalizations.of(context)!.reviewOrder,
      'orderAdded': AppLocalizations.of(context)!.orderAdded,
      'orderUpdated': AppLocalizations.of(context)!.orderUpdated,
      'success': AppLocalizations.of(context)!.success,
      'goToHome': AppLocalizations.of(context)!.goToHome,
      'customerList': AppLocalizations.of(context)!.customerList,
      'searchCustomer': AppLocalizations.of(context)!.searchCustomer,
      'customerDetails': AppLocalizations.of(context)!.customerDetails,
      'firstName': AppLocalizations.of(context)!.firstName,
      'firstNamePlaceHolder': AppLocalizations.of(context)!.firstNamePLaceHolder,
      'lastName': AppLocalizations.of(context)!.lastName,
      'lastNamePlaceHolder': AppLocalizations.of(context)!.lastNamePLaceHolder,
      'phoneNumber': AppLocalizations.of(context)!.phoneNumber,
      'editCustomer': AppLocalizations.of(context)!.editCustomer,
      'addCustomer': AppLocalizations.of(context)!.addCustomer,
      'darkMode': AppLocalizations.of(context)!.darkMode,
      'language': AppLocalizations.of(context)!.language,
      'noPendingOrders': AppLocalizations.of(context)!.noPendingOrders,
      'noInProgressOrders': AppLocalizations.of(context)!.noInProgressOrders,
      'noCompletedOrders': AppLocalizations.of(context)!.noCompletedOrders,
      'noCollectedOrders': AppLocalizations.of(context)!.noCollectedOrders,



    };
    return translations[key]!;
  }
}
