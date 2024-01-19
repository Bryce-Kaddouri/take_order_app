import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/provider/auth_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.languageScreen);
              },
            ),
            ListTile(
              title: Text('Theme'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.themeScreen);
              },
            ),
            ListTile(
              title: Text('Currency'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.currencyScreen);
              },
            ),
            ListTile(
              title: Text('Notification'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.notificationScreen);
              },
            ),
            ListTile(
              title: Text('About'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.aboutScreen);
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.privacyPolicyScreen);
              },
            ),
            ListTile(
              title: Text('Terms & Conditions'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.termsAndConditionsScreen);
              },
            ),
            ListTile(
              title: Text('FAQ'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.faqScreen);
              },
            ),
            ListTile(
              title: Text('Contact Us'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.contactUsScreen);
              },
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigator.pushNamed(context, Routes.logoutScreen);
                context.read<AuthProvider>().logout();
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
