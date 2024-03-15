import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/constant/app_color.dart';
import 'package:take_order_app/src/core/helper/responsive_helper.dart';

import '../../../../core/helper/date_helper.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final menuController = fluent.FlyoutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: fluent.FluentTheme.of(context).shadowColor,
        surfaceTintColor: fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor: fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        elevation: 4,
        title: const Text('Home'),
        actions: [
          fluent.FlyoutTarget(
            controller: menuController,
            child: CircleAvatar(
              child: InkWell(
                onTap: () {
                  menuController.showFlyout(
                    placementMode: fluent.FlyoutPlacementMode.bottomCenter,
                    autoModeConfiguration: fluent.FlyoutAutoConfiguration(
                      preferredMode: fluent.FlyoutPlacementMode.bottomRight,
                    ),
                    barrierDismissible: true,
                    dismissOnPointerMoveAway: false,
                    dismissWithEsc: true,
/*
                    navigatorKey: rootNavigatorKey.currentState,
*/
                    builder: (context) {
                      return fluent.FlyoutContent(
                        constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fluent.ListTile(
                              onPressed: () {
                                context.go('/profile');
                              },
                              leading: const Icon(fluent.FluentIcons.contact),
                              title: const Text('Profile'),
                            ),
                            fluent.ListTile(
                              tileColor: fluent.ButtonState.all(AppColor.canceledForegroundColor),
                              onPressed: () async {
                                bool? isConfirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => fluent.ContentDialog(
                                    constraints: BoxConstraints(maxWidth: 350, maxHeight: MediaQuery.of(context).size.height * 0.8),
                                    title: Container(
                                      alignment: Alignment.center,
                                      child: const Text('Logout'),
                                    ),
                                    content: Container(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Icon(
                                            fluent.FluentIcons.warning,
                                            size: 80,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          const Text('Are you sure you want to logout?'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      fluent.Button(
                                        child: const Text('No'),
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                      ),
                                      fluent.FilledButton(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    ],
                                  ),
                                );

                                if (isConfirmed != null && isConfirmed) {
                                  context.read<AuthProvider>().logout().then((value) => context.go('/signin'));
                                }
                              },
                              leading: const Icon(fluent.FluentIcons.sign_out, color: AppColor.canceledBackgroundColor),
                              title: const Text('Sign Out', style: TextStyle(color: AppColor.canceledBackgroundColor)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(fluent.FluentIcons.contact),
              ),
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),
      body: fluent.GridView(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveHelper.isMobile(context)
                ? 2
                : ResponsiveHelper.isTablet(context)
                    ? 3
                    : 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1),
        children: [
          fluent.Card(
            child: InkWell(
              onTap: () {
                context.go('/orders');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(fluent.FluentIcons.product_list, size: 50),
                  SizedBox(height: 10),
                  Text('Order List', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          fluent.Card(
            child: InkWell(
              onTap: () {
                context.go('/orders/add');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(fluent.FluentIcons.product_release, size: 50),
                  SizedBox(height: 10),
                  Text('Add Order', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          fluent.Card(
            child: InkWell(
              onTap: () {
                String date = DateHelper.getFormattedDate(DateTime.now());
                context.go('/track-order/$date');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(fluent.FluentIcons.streaming, size: 50),
                  SizedBox(height: 10),
                  Text('Track Order', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          fluent.Card(
            child: InkWell(
              onTap: () {
                context.go('/customers');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(fluent.FluentIcons.group, size: 50),
                  SizedBox(height: 10),
                  Text('Client List', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
          fluent.Card(
            child: InkWell(
              onTap: () {
                context.go('/customers/add');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(fluent.FluentIcons.add_group, size: 50),
                  SizedBox(height: 10),
                  Text('Add Client', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
