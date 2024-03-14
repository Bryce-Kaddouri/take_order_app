import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../provider/customer_provider.dart';

class AddCustomerScreen extends StatefulWidget {
  AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _countryCodeController = TextEditingController(text: '353');

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: material.AppBar(
        centerTitle: true,
        shadowColor: FluentTheme.of(context).shadowColor,
        surfaceTintColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        elevation: 4,
        leading: material.BackButton(
          onPressed: () async {
            bool? isConfirmed = await showDialog<bool>(
              context: context,
              builder: (context) => ContentDialog(
                constraints: BoxConstraints(maxWidth: 350, maxHeight: MediaQuery.of(context).size.height * 0.8),
                title: Row(children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text('Confirmation'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: const Icon(FluentIcons.clear),
                  ),
                ]),
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
                        FluentIcons.warning,
                        size: 80,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      const Text('Are you sure you want to cancel?'),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                actions: [
                  Button(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  FilledButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            );

            if (isConfirmed != null && isConfirmed) {
              context.go('/orders');
            }
          },
        ),
        title: const Text('Add Customer'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              InfoLabel(
                label: 'First Name',
                child: TextFormBox(
                  controller: _firstNameController,
                  placeholder: 'Enter your first name',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    // check if is text
                  ]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InfoLabel(
                label: 'Last Name',
                child: TextFormBox(
                  controller: _lastNameController,
                  placeholder: 'Enter your last name',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    // check if is text
                  ]),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InfoLabel(
                label: 'Phone Number',
                child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  constraints: BoxConstraints(maxWidth: 500, maxHeight: 100),
                  child: material.Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: IntlPhoneField(
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),

                        FormBuilderValidators.minLength(9),
                        FormBuilderValidators.maxLength(9),
                        // check if is text
                      ]),
                      flagsButtonPadding: EdgeInsets.all(10),
                      decoration: material.InputDecoration(
                        filled: true,
                        fillColor: FluentTheme.of(context).inactiveBackgroundColor,
                        hintText: 'Phone Number',
                      ),
                      initialCountryCode: 'IE',
                      controller: _phoneNumberController,
                      onCountryChanged: (phone) {
                        setState(() {
                          print(phone.code);
                          print(phone.dialCode);

                          _countryCodeController.text = phone.dialCode;
                        });
                      },
                      pickerDialogStyle: PickerDialogStyle(
                        backgroundColor: FluentTheme.of(context).inactiveBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String firstName = _firstNameController.text;
                      String lastName = _lastNameController.text;
                      String countryCode = '+${_countryCodeController.text}';
                      String phoneNumber = _phoneNumberController.text;
                      print('firstName: $firstName');
                      print('lastName: $lastName');
                      print('countryCode: $countryCode');
                      print('phoneNumber: $phoneNumber');

                      await context.read<CustomerProvider>().addCustomer(firstName, lastName, phoneNumber, countryCode, context).then((value) {
                        if (value) {
                          _formKey.currentState?.reset();
                        }
                      });
                    }
                  },
                  child: context.watch<CustomerProvider>().isLoading
                      ? const ProgressRing()
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
