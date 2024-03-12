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
      },*/ /*

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
  );*/ /*

}
*/

import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/features/customer/presentation/screen/customer_list_screen.dart';
import 'package:take_order_app/src/features/order/presentation/screen/order_screen.dart';
import 'package:take_order_app/src/features/order_detail/screen/order_detail_screen.dart';
import 'package:take_order_app/src/features/order_detail/screen/order_update_screen.dart';
import 'package:take_order_app/src/features/track_order/presentation/screen/track_order_screen.dart';

import '../../features/auth/presentation/provider/auth_provider.dart';
import '../../features/auth/presentation/screen/signin_screen.dart';
import '../../features/order/presentation/screen/add_order_screen.dart';
import '../../features/track_order/presentation/screen/order_track_detail_screen.dart';

class RouterHelper {
  GoRouter getRouter(BuildContext context) {
    return GoRouter(
      errorBuilder: (context, state) {
        return ScaffoldPage(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Page not found'),
              SizedBox(height: 10),
              FilledButton(
                onPressed: () {
                  DateTime date = DateTime.now();
                  String formattedDate = DateHelper.getFormattedDate(date);
                  context.go('/orders/$formattedDate');
                },
                child: Text('Go to home'),
              ),
            ],
          ),
        );
      },
      redirect: (context, state) {
        bool isLoggedIn = context.read<AuthProvider>().checkIsLoggedIn();
        print('is logged in: $isLoggedIn');
        if (isLoggedIn) {
          print(state.path);
          return state.path == '/' ? '/orders' : null;
        } else {
          return '/signin';
        }
      },
      routes: [
        GoRoute(
          path: '/track-order/:date',
          builder: (context, state) {
            DateTime orderDate = DateTime.parse(state.pathParameters['date']!);
            orderDate.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
            return TrackOrderScreen(orderDate: orderDate);
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                int orderId = int.parse(state.pathParameters['id']!);
                DateTime orderDate = DateTime.parse(state.pathParameters['date']!);
                return OrderTrackDetailScreen(orderId: orderId, orderDate: orderDate);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/orders/:date',
          builder: (context, state) {
            DateTime orderDate = DateTime.parse(state.pathParameters['date']!);
            return OrderScreen(
              selectedDate: orderDate,
            );
          },
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) {
                return AddOrderScreen();
              },
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                print(state.pathParameters);
                if (state.pathParameters.isEmpty || state.pathParameters['id'] == null || state.pathParameters['date'] == null) {
                  return ScaffoldPage(
                      content: Center(
                    child: Text('Loading...'),
                  ));
                } else {
                  int orderId = int.parse(state.pathParameters['id']!);
                  DateTime orderDate = DateTime.parse(state.pathParameters['date']!);
                  return OrderDetailScreen(orderId: orderId, orderDate: orderDate);
                }
              },
              routes: [
                GoRoute(
                  path: 'update',
                  builder: (context, state) {
                    if (state.pathParameters.isEmpty || state.pathParameters['id'] == null || state.pathParameters['date'] == null) {
                      return ScaffoldPage(
                          content: Center(
                        child: Text('Loading...'),
                      ));
                    } else {
                      int orderId = int.parse(state.pathParameters['id']!);
                      DateTime orderDate = DateTime.parse(state.pathParameters['date']!);
                      return OrderUpdateScreen(orderId: orderId, orderDate: orderDate);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
            path: '/signin',
            builder: (context, state) {
              return SignInScreen();
            }),
        GoRoute(
          path: '/customers',
          builder: (context, state) {
            return CustomerListScreen();
          },
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) {
                return ScaffoldPage(
                    content: Center(
                  child: Text('Add Customer'),
                ));
              },
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                return ScaffoldPage(
                    content: Center(
                  child: Text('Customer Details'),
                ));
              },
            ),
          ],
        ),
      ],
    );
  }
}
