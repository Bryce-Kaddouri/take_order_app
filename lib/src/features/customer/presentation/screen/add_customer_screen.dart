import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddCustomerScreen extends StatelessWidget {
  AddCustomerScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  FormBuilderTextField buildTextField(
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
              ? [FilteringTextInputFormatter.digitsOnly]
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
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
              buildTextField(
                'last_name',
                'First Name',
                'Enter your last name',
                FormBuilderValidators.compose([
                  FormBuilderValidators.required(),

                  // check if is text
                ]),
                false,
                false,
              ),
              buildTextField(
                'phone_number',
                'Phone Number',
                'Enter your phone number (0858845144)',
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
            ],
          ),
        ),
      ),
    );
  }
}
