import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:take_order_app/src/features/auth/data/model/user_model.dart';
import 'package:take_order_app/src/features/auth/presentation/provider/auth_provider.dart';
import 'package:take_order_app/src/features/profile/presentation/provider/profile_provider.dart';
import '../../../../../main.dart';

class ProfileScreen extends fluent.StatefulWidget {
  const ProfileScreen({super.key});

  @override
  fluent.State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends fluent.State<ProfileScreen> {
  UserModel? user;
  final splitButtonKey = GlobalKey<SplitButtonState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      User? currentUser = context.read<AuthProvider>().getUser();
      user = UserModel.fromUser(currentUser!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            context.go('/');
          },
        ),
        centerTitle: true,
        shadowColor: fluent.FluentTheme.of(context).shadowColor,
        surfaceTintColor:
            fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor:
            fluent.FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        elevation: 4,
        title: Text(TranslationHelper(context: context).getTranslation('profile')),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: fluent.Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: FluentTheme.of(context).menuColor,
              width: double.infinity,
              child: fluent.Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: fluent.CircleAvatar(
                      radius: 50,
                      child: fluent.Icon(fluent.FluentIcons.contact, size: 50),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${user!.fName} ${user!.lName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // lsitile swith to change theme
            fluent.ListTile(
              contentPadding:
                  const EdgeInsets.only(top: 20, bottom: 20, right: 20),
              tileColor:
                  fluent.ButtonState.all(FluentTheme.of(context).menuColor),
              title: Text(TranslationHelper(context: context).getTranslation('darkMode')),
              leading: const Icon(fluent.FluentIcons.clear_night),
              trailing: fluent.ToggleSwitch(
                checked: context.watch<ProfileProvider>().themeMode == 'dark'
                    ? true
                    : false,
                onChanged: (value) {
                  context
                      .read<ProfileProvider>()
                      .setThemeMode(value ? 'dark' : 'light');
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            fluent.ListTile(
              onPressed: () {},
              contentPadding:
                  const EdgeInsets.only(top: 20, bottom: 20, right: 20),
              tileColor:
                  fluent.ButtonState.all(FluentTheme.of(context).menuColor),
              title: Text(TranslationHelper(context: context).getTranslation('language')),
              leading: const Icon(fluent.FluentIcons.globe),
              trailing: SplitButton(
                key: splitButtonKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadiusDirectional.horizontal(
                      start: Radius.circular(4.0),
                    ),
                  ),
                  height: 32,
                  child: Text(
                    'English',
                  ),
                ),
                flyout: FlyoutContent(
                  constraints: BoxConstraints(maxWidth: 200.0),
                  child: fluent.Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      fluent.ListTile.selectable(
                        selected: true,
                        title: const Text('English'),
                        onPressed: () {
                          /*splitButtonKey.currentState!.close();*/
                          context.read<ProfileProvider>().setLanguageCode('en');
                        },
                      ),
                      fluent.ListTile.selectable(
                        selected: false,
                        title: const Text('French'),
                        onPressed: () {
                          /*splitButtonKey.currentState!.close();*/
                          context.read<ProfileProvider>().setLanguageCode('fr');
                        },
                      ),
                      fluent.ListTile.selectable(
                        selected: false,
                        title: const Text('Deutsch'),
                        onPressed: () {
                          /*splitButtonKey.currentState!.close();*/
                        },
                      ),
                      fluent.ListTile.selectable(
                        selected: false,
                        title: const Text('Chinese'),
                        onPressed: () {
                          /*splitButtonKey.currentState!.close();*/
                          context.read<ProfileProvider>().setLanguageCode('zh');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
