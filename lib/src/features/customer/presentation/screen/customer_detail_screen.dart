import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/order/data/model/order_model.dart';
import 'package:take_order_app/src/features/order/presentation/widget/order_item_view_by_status_widget.dart';

import '../../../../core/helper/date_helper.dart';
import '../../../order/presentation/provider/order_provider.dart';
import '../../data/model/customer_model.dart';
import '../provider/customer_provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;
  CustomerDetailScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  CustomerModel? customer;
  List<Map<DateTime, List<OrderModel>>> distinctOrders = [];

  // controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _countryCodeController = TextEditingController(text: '353');

  bool isLoading = true;

  void initData(BuildContext context) {
    context.read<CustomerProvider>().setIsEditingCustomer(false);
    Future.wait([context.read<OrderProvider>().getOrdersByCustomerId(widget.customerId), context.read<CustomerProvider>().getCustomerById(widget.customerId)]).then((value) {
      print('value: $value');

      List<OrderModel> ordersTemp = value[0] as List<OrderModel>;
      CustomerModel? customerTemp = value[1] as CustomerModel?;

      if (ordersTemp.isNotEmpty) {
        // disctinc date from orders
        List<Map<DateTime, List<OrderModel>>> distinctOrdersTemp = [];
        ordersTemp.fold({}, (previousValue, element) {
          if (previousValue.containsKey(element.date)) {
            previousValue[element.date].add(element);
          } else {
            previousValue[element.date] = [element];
          }
          return previousValue;
        }).forEach((key, value) {
          distinctOrdersTemp.add({key: value});
        });
        setState(() {
          distinctOrders = distinctOrdersTemp;
        });
      }
      if (customerTemp != null) {
        setState(() {
          customer = customerTemp;
          _firstNameController.text = customerTemp!.fName;
          _lastNameController.text = customerTemp!.lName;
          _phoneNumberController.text = customerTemp!.phoneNumber;
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initData(context);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      appBar: material.AppBar(
        leading: material.BackButton(
          onPressed: () {
            context.go('/customers');
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (context.read<CustomerProvider>().isEditingCustomer) {
                if (_formKey.currentState!.validate()) {
                  String firstName = _firstNameController.text;
                  String lastName = _lastNameController.text;
                  String countryCode = '+${_countryCodeController.text}';
                  String phoneNumber = _phoneNumberController.text;
                  print('firstName: $firstName');
                  print('lastName: $lastName');
                  print('countryCode: $countryCode');
                  print('phoneNumber: $phoneNumber');

                  await context.read<CustomerProvider>().updateCustomer(widget.customerId, firstName, lastName, phoneNumber, countryCode, context).then((value) {
                    if (value) {
                      initData(context);
                      context.read<CustomerProvider>().setIsEditingCustomer(false);
                    }
                  });
                }
              } else {
                context.read<CustomerProvider>().setIsEditingCustomer(true);
              }
            },
            icon: context.watch<CustomerProvider>().isLoading
                ? ProgressRing()
                : context.watch<CustomerProvider>().isEditingCustomer
                    ? Icon(FluentIcons.save, size: 20)
                    : Icon(FluentIcons.edit, size: 20),
          ),
        ],
        title: const Text('Customer Details'),
      ),
      body: Container(
          child: customer == null || isLoading
              ? const Center(
                  child: ProgressRing(),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InfoLabel(
                        label: 'First Name:',
                        child: TextFormBox(
                          readOnly: !context.watch<CustomerProvider>().isEditingCustomer,
                          controller: _firstNameController,
                          placeholder: 'Enter your first name',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            // check if is text
                          ]),
                        ),
                      ),
                      InfoLabel(
                        label: 'Last Name:',
                        child: TextFormBox(
                          readOnly: !context.watch<CustomerProvider>().isEditingCustomer,
                          controller: _lastNameController,
                          placeholder: 'Enter your last name',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            // check if is text
                          ]),
                        ),
                      ),
                      InfoLabel(
                        label: 'Phone Number:',
                        child: Container(
                          alignment: Alignment.center,
                          height: 100,
                          constraints: BoxConstraints(maxWidth: 500, maxHeight: 100),
                          child: material.Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: IntlPhoneField(
                              readOnly: !context.watch<CustomerProvider>().isEditingCustomer,
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
                      if (!context.watch<CustomerProvider>().isEditingCustomer)
                        Column(
                          children: [
                            Text('Order List'),
                            Column(
                              children: List.generate(
                                distinctOrders.length,
                                (index) {
                                  DateTime date = distinctOrders[index].keys.first;
                                  List<OrderModel> orders = distinctOrders[index].values.first;
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text(DateHelper.getFormattedDate(date)),
                                      ),
                                      Column(
                                        children: List.generate(
                                          orders.length,
                                          (index) {
                                            OrderModel order = orders[index];
                                            return OrdersItemViewByStatus(
                                              status: order.status.name,
                                              order: order,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                )),
    );
  }
}
