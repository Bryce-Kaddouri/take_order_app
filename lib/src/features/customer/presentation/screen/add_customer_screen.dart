import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
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

  final TextEditingController _countryCodeController = TextEditingController();

/*  FormBuilderTextField buildTextField(
      String name,
      String label,
      String hintText,
      String? Function(String?)? validator,
      bool isInt,
      bool isPhone) {
    return FormBuilderTextField(
      keyboardType: isInt
          ? TextInputType.number
          : isPhone
              ? TextInputType.phone
              : TextInputType.text,
      inputFormatters: isInt
          ? [FilteringTextInputFormatter.digitsOnly]
          : isPhone
      // only numbers and 10 digits
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),LengthLimitingTextInputFormatter(10)]
              : [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
      style: TextStyle(
        fontSize: 20,
      ),
      name: name,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[700],
          fontSize: 20,
        ),
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        label: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 2,
            color: Colors.blueAccent,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
      validator: validator,
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        leading: material.BackButton(
          onPressed: () {
            context.go('/orders');
          },
        ),
        title: const Text('Add Customer'),
      ),
      body: /*SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child:Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
              // text field for first name
              buildTextField(
                'first_name',
                'First Name',
                'Enter your first name',
                FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  // check if is text
                ]),
                false,
                false,
              ),
              SizedBox(height: 50,),
              buildTextField(
                'last_name',
                'Last Name',
                'Enter your last name',
                FormBuilderValidators.compose([
                  FormBuilderValidators.required(),

                  // check if is text
                ]),
                false,
                false,
              ),
              SizedBox(height: 50,),
              buildTextField(
                'phone_number',
                'Phone Number',
                '0858845144',
                FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.minLength(10),
                  FormBuilderValidators.maxLength(10),
                  // check if is text
                ]),
                false,
                true,
              ),
            ],),),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                child:
              MaterialButton(
                  color: Theme.of(context).colorScheme.secondary,

                  onPressed: () async{

                if (_formKey.currentState!.saveAndValidate()) {
                  debugPrint(_formKey.currentState?.value.toString());
                  String firstName = _formKey.currentState?.value['first_name'];
                  String lastName = _formKey.currentState?.value['last_name'];
                  String phoneNumber = _formKey.currentState?.value['phone_number'];

                  await context.read<CustomerProvider>().addCustomer(firstName, lastName, phoneNumber, context).then((value) {
                    if(value != null){
                      Animation<double> animation = Tween<double>(begin: 1, end: 0).animate(
                        CurvedAnimation(
                          parent: ModalRoute.of(context)!.animation!,
                          curve: Curves.easeIn,
                        ),
                      );
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          animation: animation,
                          content: Text(
                            'Customer added successfully',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onVisible: () {
                            Future.delayed(const Duration(seconds: 2), () {
                              // dismiss banner
                              ScaffoldMessenger.of(context)
                                  .hideCurrentMaterialBanner();
                              context.go('/customers');
                            });
                          },
                          backgroundColor: Colors.green,
                          actions: [
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentMaterialBanner();
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
*/ /*
                      context.go('/customers');
*/ /*
                    }
                  });

                }
              },   minWidth: double.infinity,

                height: 50,
                child: context.watch<CustomerProvider>().isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
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
      ),*/

          Container(
        child: Form(
          child: Column(
            children: [
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
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter phone number';
                        } else if (value.isValidNumber() == false) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                      flagsButtonPadding: EdgeInsets.all(10),
                      decoration: material.InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        constraints: BoxConstraints(
                            maxWidth: 500, maxHeight: 100, minHeight: 100),
                        labelText: 'Phone Number',
                        border: material.OutlineInputBorder(),
                        enabledBorder: material.OutlineInputBorder(),
                        focusedBorder: material.OutlineInputBorder(),
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
                    ),
                  ),
                ),
              ),
              FilledButton(
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

                    /*await context
                        .read<CustomerProvider>()
                        .addCustomer(
                            firstName, lastName, phoneNumber, countryCode)
                        .then((value) {
                      if (value) {
                        displayInfoBar(alignment: Alignment.topRight, context,
                            builder: (context, close) {
                          return InfoBar(
                            title: const Text('Success!'),
                            content: const Text('Customer added successfully'),
                            severity: InfoBarSeverity.success,
                            action: IconButton(
                              icon: const Icon(FluentIcons.clear),
                              onPressed: close,
                            ),
                          );
                        });
                      } else {
                        displayInfoBar(alignment: Alignment.topRight, context,
                            builder: (context, close) {
                          return InfoBar(
                            title: const Text('Error!'),
                            content: const Text('Please add item first'),
                            severity: InfoBarSeverity.error,
                            action: IconButton(
                              icon: const Icon(FluentIcons.clear),
                              onPressed: close,
                            ),
                          );
                        });
                      }
                    });
                    
                     */
                  }
                },
                child: context.watch<CustomerProvider>().isLoading
                    ? const ProgressRing()
                    : const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
