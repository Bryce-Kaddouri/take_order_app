import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/main.dart';

import '../provider/auth_provider.dart';

class SignInScreen extends fluent.StatefulWidget {
  SignInScreen({super.key});

  @override
  fluent.State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends fluent.State<SignInScreen> {
  // global key for the form
  final _formKey = GlobalKey<FormState>();

  // controller for the email field
  final TextEditingController _emailController = TextEditingController();

  // controller for the password field
  final TextEditingController _passwordController = TextEditingController();

  fluent.FocusNode _emailFocusNode = fluent.FocusNode();

  fluent.FocusNode _passwordFocusNode = fluent.FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationHelper(context: context).getTranslation('helloWorld'),
        ),
      ),
      backgroundColor: fluent.FluentTheme.of(context)
          .navigationPaneTheme
          .overlayBackgroundColor,
      body: DismissKeyboard(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(children: [
                    fluent.InfoLabel(
                      label: /*'Email:',*/
                          '${TranslationHelper(context: context).getTranslation('email')}:',
                      child: fluent.TextFormBox(
                        keyboardType: TextInputType.emailAddress,
                        onTapOutside: (event) {
                          print('onTapOutside');
                          _emailFocusNode.unfocus();
                        },
                        placeholder: TranslationHelper(context: context)
                            .getTranslation('email'),
                        focusNode: _emailFocusNode,
                        controller: _emailController,
                        prefix: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(fluent.FluentIcons.mail),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    fluent.InfoLabel(
                      label:
                          '${TranslationHelper(context: context).getTranslation('password')}:',
                      child: fluent.PasswordFormBox(
                        onEditingComplete: () {
                          print('onEditingComplete');
                          _passwordFocusNode.unfocus();
                        },
                        onSaved: (value) {
                          print('onSaved');
                          _passwordFocusNode.unfocus();
                        },
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        placeholder: TranslationHelper(context: context)
                            .getTranslation('password'),
                        leadingIcon: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Icon(fluent.FluentIcons.lock),
                        ),
                        revealMode: fluent.PasswordRevealMode.peekAlways,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                    ),
                  ]),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: fluent.FilledButton(
                    style: fluent.ButtonStyle(),
                    onPressed: () {
                      // Validate and save the form values
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<AuthProvider>()
                            .login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            )
                            .then((value) {
                          print(value);
                          if (value) {
                            print('logged in');

                            context.go('/');
                          } else {
                            // show materiql banner
                            fluent.displayInfoBar(
                              context,
                              builder: (context, close) {
                                return fluent.InfoBar(
                                  title: Text(
                                    TranslationHelper(context: context)
                                        .getTranslation('error'),
                                  ),
                                  content: Text(
                                      TranslationHelper(context: context)
                                          .getTranslation(
                                              'invalidEmailOrPassword')),

                                  /*'The user has not been added because of an error. ${l.errorMessage}'*/

                                  action: IconButton(
                                    icon: const Icon(fluent.FluentIcons.clear),
                                    onPressed: close,
                                  ),
                                  severity: fluent.InfoBarSeverity.error,
                                );
                              },
                              alignment: Alignment.topRight,
                              duration: const Duration(seconds: 5),
                            );
                          }
                        });
                      }
                    },
                    child: context.watch<AuthProvider>().isLoading
                        ? const fluent.ProgressRing()
                        : Text(
                            TranslationHelper(context: context)
                                .getTranslation('signIn'),
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: PopScope(
          onPopInvoked: (val) async {
            print('onPopInvoked');
            print(val);
            FocusScope.of(context).unfocus();
            /*return false;*/
          },
          child: SafeArea(
            child: child,
          ),
        ));
  }
}
