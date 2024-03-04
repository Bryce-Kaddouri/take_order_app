import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the email field
  final TextEditingController _emailController = TextEditingController();
  // controller for the password field
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  fluent.InfoLabel(label: 'Email:',
                  child:
                  fluent.TextFormBox(

                    placeholder: 'Email',
                    controller: _emailController,
                    prefix: Container(
                      padding: const EdgeInsets.all(10),
                      child:const Icon(fluent.FluentIcons.mail),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  ),
                  const SizedBox(height: 10),
                fluent.InfoLabel(label: 'Password:',
                    child:
                  fluent.PasswordFormBox(
                    controller: _passwordController,
                    placeholder: 'Password',
                    leadingIcon: Container(
                      padding: const EdgeInsets.all(10),
                      child:const Icon(fluent.FluentIcons.lock),
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
                child:
              fluent.FilledButton(
                style: fluent.ButtonStyle(

                ),
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

                        context.go('/orders');
                      } else {
                        // show materiql banner
                        fluent.displayInfoBar(
                          context,
                          builder: (context, close) {
                            return fluent.InfoBar(
                              title: const Text('Error!'),
                              content: const Text(
                                  'Invalid email or password. Please try again.'),


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
                    ? const fluent.ProgressRing(
                      )
                    : const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
