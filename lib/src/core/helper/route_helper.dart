/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/auth/presentation/screen/signin_screen.dart';
import 'package:take_order_app/src/features/customer/presentation/screen/add_customer_screen.dart';
import 'package:take_order_app/src/features/customer/presentation/screen/customer_detail_screen.dart';
import 'package:take_order_app/src/features/customer/presentation/screen/customer_list_screen.dart';
import 'package:take_order_app/src/features/order/presentation/screen/order_screen.dart';
import 'package:take_order_app/src/features/setting/presentation/screen/setting_screen.dart';

import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/order/presentation/screen/add_order_screen.dart';

class RouterHelper {

  GoRouter getRoute() {
    return GoRouter(
     */
/* redirect: (context, state) {
        bool isLoggedIn = context.read<AuthProvider>().checkIsLoggedIn();
        print('is logged in: $isLoggedIn');
        if (isLoggedIn) {
          print(state.path);
          return state.path == '/' ? '/orders' : null;
        } else {
          return '/signin';
        }
      },*//*

      routes: <RouteBase>[

        GoRoute(
          path: '/orders',
          builder: (context, state) {
            return OrderScreen();
          },
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) {
                return AddOrderScreen();
              },
            ),
          ],
        ),
        GoRoute(
            path: '/signin',
            builder: (context, state) {
              return SignInScreen();
            }),
        GoRoute(
            path: '/setting',
            pageBuilder: (context, state) {
              return MaterialPage(child: SettingScreen());
            },
            name: 'setting'),
        GoRoute(
            path: '/customers',
            pageBuilder: (context, state) {
              return MaterialPage(child: CustomerListScreen());
            },
            name: 'customers',
            routes: [
              GoRoute(
                  path: 'add',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: AddCustomerScreen());
                  },
                  name: 'addCustomer'),
              GoRoute(
                  path: 'details/:id',
                  pageBuilder: (context, state) {
                    return MaterialPage(
                        child: CustomerDetailScreen(
                          id: int.parse(state.pathParameters['id']!),
                        ));
                  },
                  name: 'customer-details'),
            ]),
      ],
        );
  }
  */
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
  );*//*

}
*/


import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/order/presentation/screen/order_screen.dart';


import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/auth/presentation/screen/signin_screen.dart';
import '../../features/order/presentation/screen/add_order_screen.dart';
import '../helper/responsive_helper.dart';

/*class Routes {
  static const String home = '/home';
  static const String login = '/login';

  final getPages = [
    GetPage(
      participatesInRootNavigator: true,
      name: Routes.home,
      page: () => HomeScreen(),
      transition: Transition.zoom,
      children: [],
    ),
    GetPage(
      participatesInRootNavigator: true,
      name: Routes.login,
      page: () => SignInScreen(),
      transition: Transition.zoom,
      children: [],
    ),
  ];
}*/

class RouterHelper {
  GoRouter getRouter(BuildContext context) {
    return GoRouter(
      /*redirect: (context, state) {
        // check if user is logged in
        // if not, redirect to login page

        print('state: ${state.matchedLocation}');
        print('state: ${state.uri}');

        bool isLoggedIn = context.read<AuthProvider>().checkIsLoggedIn();
        print('isLoggedIn: $isLoggedIn');


        if (!isLoggedIn && state.uri.path != '/signin') {
          return '/signin';
        } else {
          return state.uri.path;
        }
      },*/
      initialLocation: context.read<AuthProvider>().checkIsLoggedIn() ? '/orders': '/signin',

            routes: [
              GoRoute(
                  path: '/orders',
                  builder: (context, state) {
                    return OrderScreen();
                  },
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) {
                        return AddOrderScreen();
                      },
                    ),
                  ],
              ),
              GoRoute(
                  path: '/signin',
                  builder: (context, state) {
                    return SignInScreen();
                  }),

            ],
    );
  }
}
