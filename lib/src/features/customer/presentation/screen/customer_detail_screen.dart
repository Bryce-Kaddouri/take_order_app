import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/main.dart';
import 'package:take_order_app/src/features/auth/presentation/screen/signin_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData(context);
    });
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
      backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: material.AppBar(
        centerTitle: true,
        shadowColor: FluentTheme.of(context).shadowColor,
        surfaceTintColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        elevation: 4,
        leading: material.BackButton(
          onPressed: () async {
            if (context.read<CustomerProvider>().isEditingCustomer) {
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
                        Text(TranslationHelper(context: context).getTranslation('confirmCancel')),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Button(
                      child: Text(TranslationHelper(context: context).getTranslation('no')),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    FilledButton(
                      child: Text(TranslationHelper(context: context).getTranslation('yes')),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                ),
              );

              if (isConfirmed != null && isConfirmed) {
                context.go('/customers');
              }
            } else {
              context.go('/customers');
            }
          },
        ),
        actions: [
          Button(
            style: ButtonStyle(
              padding: ButtonState.all(EdgeInsets.zero),
            ),
            child: Container(
              height: 40,
              width: 40,
              child: context.watch<CustomerProvider>().isLoading
                  ? ProgressRing()
                  : context.watch<CustomerProvider>().isEditingCustomer
                      ? Icon(FluentIcons.cancel, size: 20)
                      : Icon(FluentIcons.edit, size: 20),
            ),
            onPressed: () async {
              if (context.read<CustomerProvider>().isEditingCustomer) {
                context.read<CustomerProvider>().setIsEditingCustomer(false);
              } else {
                context.read<CustomerProvider>().setIsEditingCustomer(true);
              }
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
        title: Text( TranslationHelper(context: context).getTranslation(!context.watch<CustomerProvider>().isEditingCustomer ?'customerDetails' : 'editCustomer')),
      ),
      body: DismissKeyboard(
        child:
        SingleChildScrollView(child:
        Container(
          padding: const EdgeInsets.all(20),
          child: customer == null || isLoading
              ? const Center(
                  child: ProgressRing(),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InfoLabel(
                        label: '${TranslationHelper(context: context).getTranslation('firstName')}:',
                        child: TextFormBox(
                          readOnly: !context.watch<CustomerProvider>().isEditingCustomer,
                          controller: _firstNameController,
                          placeholder: TranslationHelper(context: context).getTranslation('firstNamePlaceHolder'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            // check if is text
                          ]),
                        ),
                      ),
                      InfoLabel(
                        label: '${TranslationHelper(context: context).getTranslation('lastName')}:',
                        child: TextFormBox(
                          readOnly: !context.watch<CustomerProvider>().isEditingCustomer,
                          controller: _lastNameController,
                          placeholder: TranslationHelper(context: context).getTranslation('lastNamePlaceHolder'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            // check if is text
                          ]),
                        ),
                      ),
                      InfoLabel(
                        label: '${TranslationHelper(context: context).getTranslation('phoneNumber')}:',
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
                                hintText: TranslationHelper(context: context).getTranslation('phoneNumber'),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Text(TranslationHelper(context: context).getTranslation('orderList'), style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 24)),
                            SizedBox(height: 20,),

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
                ),
        ),
        ),
      ),
    );
  }
}
