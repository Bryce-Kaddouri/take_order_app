import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:take_order_app/src/features/order/presentation/screen/order_screen.dart';

class RouterHelper {
  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          if (context.read<AuthProvider>().checkIsLoggedIn()) {
            return const MaterialPage(child: Text('Dashboard'));
          } else {
            return MaterialPage(child: OrderScreen());
          }
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Login')),
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
  );
}
