import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:take_order_app/src/features/auth/presentation/screen/signin_screen.dart';
import 'package:take_order_app/src/features/customer/presentation/screen/add_customer_screen.dart';
import 'package:take_order_app/src/features/customer/presentation/screen/customer_list_screen.dart';
import 'package:take_order_app/src/features/order/presentation/screen/order_screen.dart';
import 'package:take_order_app/src/features/setting/presentation/screen/setting_screen.dart';

class RouterHelper {
  final ValueNotifier<RoutingConfig> myRoutingConfig = ValueNotifier<RoutingConfig>(
    RoutingConfig(
      redirect: (context, state) {
        bool isLoggedIn = context.read<AuthProvider>().checkIsLoggedIn();
        if (isLoggedIn) {
          print(state.path);
          if (state.path == '/' || state.path == '/signin') {
            return '/orders';
          }else{
            return state.path;
          }

        } else {
          return '/signin';
        }
      },
      routes: <RouteBase>[
        GoRoute(path: '/orders', pageBuilder: (context, state) {
          return MaterialPage(child: OrderScreen());
        },

        ),
        GoRoute(path: '/signin', pageBuilder: (context, state) {
          return MaterialPage(child: SignInScreen());
        }),
        GoRoute(path: '/setting', pageBuilder: (context, state) {
          return MaterialPage(child: SettingScreen());
        },name: 'setting'),
        GoRoute(path: '/customers', pageBuilder: (context, state) {
          return MaterialPage(child: CustomerListScreen());
        },name: 'customers', routes: [
          GoRoute(path: 'add', pageBuilder: (context, state) {
            return MaterialPage(child: AddCustomerScreen());
          },name: 'add'),
        ]),


      ],

    ),
  );
  GoRouter getRoute(){
    return GoRouter.routingConfig(routingConfig: myRoutingConfig,observers: [NavigatorObserver()]);
  }
  /*static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          if (context.read<AuthProvider>().checkIsLoggedIn()) {
            print('logged in');
            return const MaterialPage(child: OrderScreen());
          } else {
            print('not logged in');
            return MaterialPage(child: SignInScreen());
          }
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          if (context.read<AuthProvider>().checkIsLoggedIn()) {
            return const MaterialPage(child: OrderScreen());
          } else {
            return MaterialPage(child: SignInScreen());
          }
        },
      ),
      GoRoute(
        path: '/setting',
        pageBuilder: (context, state) {
          if (context.read<AuthProvider>().checkIsLoggedIn()) {
            return const MaterialPage(child: SettingScreen());
          } else {
            return MaterialPage(child: SignInScreen());
          }
        },
      ),
      GoRoute(
        path: '/add-customer',
        pageBuilder: (context, state) =>
            MaterialPage(child: AddCustomerScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Register')),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Forgot Password')),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Dashboard')),
      ),
      GoRoute(
        path: '/dashboard/users',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Users')),
      ),
      GoRoute(
        path: '/dashboard/users/add',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Add User')),
      ),
      GoRoute(
        path: '/dashboard/users/edit/:id',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Edit User')),
      ),
      GoRoute(
        path: '/dashboard/products',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Products')),
      ),
      GoRoute(
        path: '/dashboard/products/add',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Add Product')),
      ),
      GoRoute(
        path: '/dashboard/products/edit/:id',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Edit Product')),
      ),
    ],
  );*/
}
