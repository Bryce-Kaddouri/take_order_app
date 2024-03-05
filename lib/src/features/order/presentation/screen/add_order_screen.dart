import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:take_order_app/src/features/product/presentation/provider/product_provider.dart';

import '../../../customer/data/model/customer_model.dart';
import '../../../product/data/model/product_model.dart';
import '../provider/order_provider.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  ScrollController stepScrollController = ScrollController();
  int currentStep = 0;
  final _formKeyCustomer = GlobalKey<FormState>();
  final DateTime selected = DateTime.now().copyWith(
    hour: 9,
    minute: 0,
    second: 0,
  );
  final _fromKeyPayment = GlobalKey<FormState>();

  List<CustomerModel> lstCustomers = [];
  List<ProductModel> lstProducts = [];
  int selectedCustomerId = -1;
  DateTime selectedDate = DateTime.now();
  double numberBoxValue = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<CustomerProvider>().getCustomers().then((value) {
      setState(() {
        lstCustomers = value!;
      });
    });
    context.read<ProductProvider>().getProducts().then((value) {
      setState(() {
        lstProducts = value!;
      });
    });
  }

  int? selectedProductId;

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Customer Details';
      case 1:
        return 'Date & Time';
      case 2:
        return 'Fill Order';
      case 3:
        return 'Review Order';
      case 4:
        return 'Payment Detail';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: Text(getTitle(currentStep)),
      ),
      bottomBar: fluent.Card(
        child: fluent.Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            fluent.Button(
                child: fluent.Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  child: fluent.Row(
                    children: [
                      fluent.Icon(fluent.FluentIcons.back),
                      fluent.SizedBox(
                        width: 10,
                      ),
                      fluent.Text('Back')
                    ],
                  ),
                ),
                onPressed: currentStep == 0
                    ? null
                    : () {
                        if (currentStep > 0) {
                          setState(() {
                            currentStep -= 1;
                          });
                        }
                      }),
            fluent.Button(
                child: fluent.Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  child: fluent.Row(
                    children: [
                      fluent.Icon(fluent.FluentIcons.forward),
                      fluent.SizedBox(
                        width: 10,
                      ),
                      fluent.Text('Next')
                    ],
                  ),
                ),
                onPressed: () {
                  print(currentStep);
                  setState(() {
                    currentStep += 1;
                  });
                }),
          ],
        ),
      ),
      content: fluent.Column(
        children: [
          fluent.Container(
            padding: EdgeInsets.all(10),
            height: 60,
            width: double.infinity,
            child: fluent.LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              double width = constraints.maxWidth;
              double itemWidth = (width - (40 * 6)) / 5;
              return fluent.Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep >= 0 ? Colors.green : Colors.grey,
                    ),
                    child: fluent.Text('1'),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 60,
                    width: itemWidth,
                    alignment: Alignment.centerLeft,
                    child: fluent.Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: currentStep == 0 ? [Colors.green, Colors.green, Colors.grey, Colors.grey] : [Colors.green, Colors.green, Colors.green, Colors.green],
                          stops: [0.0, 0.5, 0.5, 1],
                        ),
                      ),
                      width: itemWidth,
                      height: 2,
                    ),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep >= 1 ? Colors.green : Colors.grey,
                    ),
                    child: fluent.Text('2'),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 60,
                    width: itemWidth,
                    alignment: Alignment.centerLeft,
                    child: fluent.Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: currentStep < 1
                              ? [Colors.grey, Colors.grey, Colors.grey, Colors.grey]
                              : currentStep == 1
                                  ? [Colors.green, Colors.green, Colors.grey, Colors.grey]
                                  : [Colors.green, Colors.green, Colors.green, Colors.green],
                          stops: [0.0, 0.5, 0.5, 1],
                        ),
                      ),
                      width: itemWidth,
                      height: 2,
                    ),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep >= 2 ? Colors.green : Colors.grey,
                    ),
                    child: fluent.Text('3'),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 60,
                    width: itemWidth,
                    alignment: Alignment.centerLeft,
                    child: fluent.Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: currentStep < 2
                              ? [Colors.grey, Colors.grey, Colors.grey, Colors.grey]
                              : currentStep == 2
                                  ? [Colors.green, Colors.green, Colors.grey, Colors.grey]
                                  : [Colors.green, Colors.green, Colors.green, Colors.green],
                          stops: [0.0, 0.5, 0.5, 1],
                        ),
                      ),
                      width: itemWidth,
                      height: 2,
                    ),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep >= 3 ? Colors.green : Colors.grey,
                    ),
                    child: fluent.Text('4'),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 60,
                    width: itemWidth,
                    alignment: Alignment.centerLeft,
                    child: fluent.Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: currentStep < 3
                              ? [Colors.grey, Colors.grey, Colors.grey, Colors.grey]
                              : currentStep == 3
                                  ? [Colors.green, Colors.green, Colors.grey, Colors.grey]
                                  : [Colors.green, Colors.green, Colors.green, Colors.green],
                          stops: [0.0, 0.5, 0.5, 1],
                        ),
                      ),
                      width: itemWidth,
                      height: 2,
                    ),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep >= 4 ? Colors.green : Colors.grey,
                    ),
                    child: fluent.Text('5'),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 60,
                    width: itemWidth,
                    alignment: Alignment.centerLeft,
                    child: fluent.Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: currentStep < 4
                              ? [Colors.grey, Colors.grey, Colors.grey, Colors.grey]
                              : currentStep == 4
                                  ? [Colors.green, Colors.green, Colors.grey, Colors.grey]
                                  : [Colors.green, Colors.green, Colors.green, Colors.green],
                          stops: [0.0, 0.5, 0.5, 1],
                        ),
                      ),
                      width: itemWidth,
                      height: 2,
                    ),
                  ),
                  fluent.Container(
                    padding: EdgeInsets.all(0),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentStep >= 5 ? Colors.green : Colors.grey,
                    ),
                    child: fluent.Icon(fluent.FluentIcons.check_mark),
                  ),
                ],
              );
            }),
          ),
          fluent.Expanded(
            child: fluent.PageView(children: [
              // page for customer
              fluent.Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: fluent.Form(
                  key: _formKeyCustomer,
                  child: fluent.Column(
                    children: [
                      fluent.Container(
                        constraints: fluent.BoxConstraints(
                          maxHeight: 40,
                        ),
                        height: 40,
                        width: double.infinity,
                        child: fluent.AutoSuggestBox.form(placeholder: 'Select Customer', items: List.generate(lstCustomers.length, (index) => fluent.AutoSuggestBoxItem<String>(label: '${lstCustomers[index].fName} ${lstCustomers[index].lName}', value: '${lstCustomers[index].id}'))),
                      ),
                    ],
                  ),
                ),
              ),
              // page for date and time
              fluent.Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: fluent.Column(
                  children: [
                    fluent.DatePicker(
                      header: 'Pick a date',
                      selected: selected,
                      onChanged: (time) {
                        setState(() {
                          selectedDate = time;
                        });
                      },
                    ),
                    fluent.SizedBox(
                      height: 10,
                    ),
                    fluent.TimePicker(
                      selected: selected,
                      onChanged: (DateTime time) {
                        setState(() {
                          selectedDate = time;
                        });
                      },
                      hourFormat: fluent.HourFormat.HH,
                    ),
                  ],
                ),
              ),
              // page for fill order
              fluent.Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: fluent.Container(
                  child: context.watch<OrderProvider>().cartList.isNotEmpty
                      ? fluent.Column(
                          children: List.generate(
                            context.watch<OrderProvider>().cartList.length,
                            (index) {
                              return fluent.Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child: fluent.ListTile(
                                  onPressed: () async {
                                    // global key for form builder
                                    final _formKeyQty = GlobalKey<FormBuilderState>();

                                    /* showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return fluent.AlertDialog(
                                        actions: [
                                          fluent.TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: fluent.Text('Cancel'),
                                          ),
                                          fluent.TextButton(
                                            onPressed: () {
                                              if (_formKeyQty.currentState!.validate()) {
                                                context.read<OrderProvider>().updateQuantityCartList(index, int.parse(_formKeyQty.currentState!.fields['quantity']!.value.toString()));
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: fluent.Text('Confirm'),
                                          ),
                                        ],
                                        title: fluent.Text('Edit Quantity'),
                                        content: fluent.Container(
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          height: 100,
                                          child: fluent.FormBuilder(
                                            key: _formKeyQty,
                                            child: fluent.Column(
                                              children: [
                                                fluent.FormBuilderTextField(
                                                  initialValue: context.watch<OrderProvider>().cartList[index].quantity.toString(),
                                                  autofocus: true,
                                                  name: 'quantity',
                                                  decoration: InputDecoration(
                                                    labelText: 'Quantity',
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  validator: FormBuilderValidators.compose([
                                                    FormBuilderValidators.required(),
                                                    FormBuilderValidators.numeric(),
                                                    // check > 0
                                                    FormBuilderValidators.min(1),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });*/
                                  },
                                  title: fluent.Text('${context.watch<OrderProvider>().cartList[index].product.name}'),
                                  subtitle: fluent.Text('${context.watch<OrderProvider>().cartList[index].product.price}'),
                                  trailing: fluent.Container(
                                    child: fluent.Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        fluent.IconButton(
                                          onPressed: () {
                                            int currentQty = context.read<OrderProvider>().cartList[index].quantity;
                                            if (currentQty > 1) {
                                              context.read<OrderProvider>().updateQuantityCartList(index, currentQty - 1);
                                            } else {
                                              context.read<OrderProvider>().removeCartList(context.read<OrderProvider>().cartList[index]);
                                            }
                                          },
                                          icon: fluent.Icon(fluent.FluentIcons.remove),
                                        ),
                                        fluent.Text(context.watch<OrderProvider>().cartList[index].quantity.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                            )),
                                        fluent.IconButton(
                                          onPressed: () {
                                            int currentQty = context.read<OrderProvider>().cartList[index].quantity;
                                            context.read<OrderProvider>().updateQuantityCartList(index, currentQty + 1);
                                          },
                                          icon: fluent.Icon(fluent.FluentIcons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : fluent.Center(
                          child: fluent.Text(
                            'No item added\nPlease add item first',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                ),
              ),
            ]),
          ),
        ],
      ),
      /*fluent.Column(
            children: [
              Stepper(
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      TextButton(
                        onPressed: currentStep != 0
                            ? () {
                                if (currentStep > 0) {
                                  setState(() {
                                    currentStep -= 1;
                                  });
                                }
                              }
                            : null,
                        child: Text('Back'),
                      ),
                      if (currentStep == 5)
                        TextButton(
                          onPressed: () {
                            */ /*List<CartModel> cartList =
                        context.read<OrderProvider>().cartList;
                    CustomerModel customer = lstCustomers.firstWhere(
                        (element) =>
                            element.id ==
                            _formKeyCustomer
                                .currentState!.fields['customer_id']!.value);
                    double paymentAmount = double.parse(_fromKeyPayment
                        .currentState!.fields['payment_amount']!.value
                        .toString());
                    DateTime orderDate = _formKeyDateTime
                        .currentState!.fields['order_date']!.value;
                    TimeOfDay orderTime = TimeOfDay.fromDateTime(
                        _formKeyDateTime
                            .currentState!.fields['order_time']!.value);
                    String note = _fromKeyPayment
                        .currentState!.fields['note']!.value
                        .toString();

                    PlaceOrderModel placeOrderModel = PlaceOrderModel(
                      cartList: cartList,
                      customer: customer,
                      paymentAmount: paymentAmount,
                      orderDate: orderDate,
                      orderTime: orderTime,
                      note: note,
                    );

                    context
                        .read<OrderProvider>()
                        .placeOrder(placeOrderModel)
                        .then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order added'),
                          ),
                        );
                        context.go('/orders');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error adding order'),
                          ),
                        );
                      }
                    });*/ /*
                          },
                          child: Text('Confirm'),
                        ),
                      if (currentStep < 5)
                        TextButton(
                          onPressed: () {
                            print(currentStep);
                            if (currentStep < 5) {
                              if (currentStep == 0) {
                                if (_formKeyCustomer.currentState!.validate()) {
                                  setState(() {
                                    currentStep += 1;
                                  });
                                } else {
                                  print('invalid');
                                }
                              } else if (currentStep == 1) {
                                */ /*if (_formKeyDateTime.currentState!.validate()) {
                          setState(() {
                            currentStep += 1;
                          });
                        } else {
                          print('invalid');
                        }*/ /*
                                setState(() {
                                  currentStep += 1;
                                });
                              } else if (currentStep == 2) {
                                if (context.read<OrderProvider>().cartList.isNotEmpty) {
                                  setState(() {
                                    currentStep += 1;
                                  });
                                } else {
                                  print('invalid');
                                }
                              } else if (currentStep == 3) {
                                if (context.read<OrderProvider>().cartList.isNotEmpty) {
                                  setState(() {
                                    currentStep += 1;
                                  });
                                } else {
                                  print('invalid');
                                }
                              } else if (currentStep == 4) {
                                setState(() {
                                  currentStep += 1;
                                });
                              }
                            }
                          },
                          child: Text('Next'),
                        ),
                    ],
                  );
                },
                physics: AlwaysScrollableScrollPhysics(),
                controller: stepScrollController,
                onStepCancel: () {
                  if (currentStep > 0) {
                    setState(() {
                      currentStep -= 1;
                    });
                  }
                },
                onStepContinue: () {
                  print(currentStep);
                  if (currentStep < 5) {
                    if (currentStep == 0) {
                      if (_formKeyCustomer.currentState!.validate()) {
                        setState(() {
                          currentStep += 1;
                        });
                      } else {
                        print('invalid');
                      }
                    } else if (currentStep == 1) {
                      */ /* if (_formKeyDateTime.currentState!.validate()) {
                setState(() {
                  currentStep += 1;
                });
              } else {
                print('invalid');
              }*/ /*
                      setState(() {
                        currentStep += 1;
                      });
                    } else if (currentStep == 2) {
                      if (context.read<OrderProvider>().cartList.isNotEmpty) {
                        setState(() {
                          currentStep += 1;
                        });
                      } else {
                        print('invalid');
                      }
                    } else if (currentStep == 3) {
                      if (context.read<OrderProvider>().cartList.isNotEmpty) {
                        setState(() {
                          currentStep += 1;
                        });
                      } else {
                        print('invalid');
                      }
                    } else if (currentStep == 4) {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  }
                },
                type: !ResponsiveHelper.isDesktop(context) ? StepperType.vertical : StepperType.horizontal,
                currentStep: currentStep,
                steps: <Step>[
                  Step(
                    isActive: currentStep >= 0,
                    title: const Text('Customer Detail'),
                    content: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: */ /*FormBuilder(
                key: _formKeyCustomer,
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      decoration: InputDecoration(
                        labelText: 'Customer',
                        hintText: 'Select Customer',
                        border: OutlineInputBorder(),
                      ),
                      name: 'customer_id',
                      items: lstCustomers.map((e) {
                        return DropdownMenuItem(
                          value: e.id,
                          child: Text('${e.fName} ${e.lName}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedCustomerId = value as int;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        // check if number
                      ]),
                    ),
                  ],
                ),
              ),*/ /*
                          fluent.Form(key: _formKeyCustomer, child: fluent.AutoSuggestBox.form(items: List.generate(lstCustomers.length, (index) => fluent.AutoSuggestBoxItem<String>(label: '${lstCustomers[index].fName} ${lstCustomers[index].lName}', value: '${lstCustomers[index].id}')))),
                    ),
                  ),
                  Step(
                    isActive: currentStep >= 1,
                    title: const Text('Date & Time'),
                    content: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          fluent.DatePicker(
                            header: 'Pick a date',
                            selected: selected,
                            onChanged: (time) {
                              setState(() {
                                selectedDate = time;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          fluent.TimePicker(
                            selected: selected,
                            onChanged: (DateTime time) {
                              setState(() {
                                selectedDate = time;
                              });
                            },
                            hourFormat: HourFormat.HH,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Step(
                    isActive: currentStep >= 2,
                    title: const Text('Fill Order'),
                    content: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: context.watch<OrderProvider>().cartList.isNotEmpty
                            ? Column(
                                children: List.generate(
                                  context.watch<OrderProvider>().cartList.length,
                                  (index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        onTap: () async {
                                          // global key for form builder
                                          final _formKeyQty = GlobalKey<FormBuilderState>();

                                          showAdaptiveDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (_formKeyQty.currentState!.validate()) {
                                                          context.read<OrderProvider>().updateQuantityCartList(index, int.parse(_formKeyQty.currentState!.fields['quantity']!.value.toString()));
                                                          Navigator.pop(context);
                                                        }
                                                      },
                                                      child: Text('Confirm'),
                                                    ),
                                                  ],
                                                  title: Text('Edit Quantity'),
                                                  content: Container(
                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                    height: 100,
                                                    child: FormBuilder(
                                                      key: _formKeyQty,
                                                      child: Column(
                                                        children: [
                                                          FormBuilderTextField(
                                                            initialValue: context.watch<OrderProvider>().cartList[index].quantity.toString(),
                                                            autofocus: true,
                                                            name: 'quantity',
                                                            decoration: InputDecoration(
                                                              labelText: 'Quantity',
                                                              border: OutlineInputBorder(),
                                                            ),
                                                            validator: FormBuilderValidators.compose([
                                                              FormBuilderValidators.required(),
                                                              FormBuilderValidators.numeric(),
                                                              // check > 0
                                                              FormBuilderValidators.min(1),
                                                            ]),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        title: Text('${context.watch<OrderProvider>().cartList[index].product.name}'),
                                        subtitle: Text('${context.watch<OrderProvider>().cartList[index].product.price}'),
                                        trailing: Container(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  int currentQty = context.read<OrderProvider>().cartList[index].quantity;
                                                  if (currentQty > 1) {
                                                    context.read<OrderProvider>().updateQuantityCartList(index, currentQty - 1);
                                                  } else {
                                                    context.read<OrderProvider>().removeCartList(context.read<OrderProvider>().cartList[index]);
                                                  }
                                                },
                                                icon: Icon(Icons.remove),
                                              ),
                                              Text(context.watch<OrderProvider>().cartList[index].quantity.toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  )),
                                              IconButton(
                                                onPressed: () {
                                                  int currentQty = context.read<OrderProvider>().cartList[index].quantity;
                                                  context.read<OrderProvider>().updateQuantityCartList(index, currentQty + 1);
                                                },
                                                icon: Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  'No item added\nPlease add item first',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Step(
                    isActive: currentStep >= 3,
                    title: const Text('Review Order'),
                    content: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: context.watch<OrderProvider>().cartList.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: List.generate(
                                        context.watch<OrderProvider>().cartList.length,
                                        (index) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text('${context.watch<OrderProvider>().cartList[index].product.name}'),
                                              subtitle: Text('${context.watch<OrderProvider>().cartList[index].product.price}'),
                                              trailing: Container(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('x${context.watch<OrderProvider>().cartList[index].quantity}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      tileColor: Colors.grey[200],
                                      title: Text('Total'),
                                      trailing: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('${context.watch<OrderProvider>().totalAmount}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'No item added\nPlease add item first',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Step(
                    isActive: currentStep >= 4,
                    title: const Text('Payment Detail'),
                    content: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: fluent.Form(
                          key: _fromKeyPayment,
                          child: Column(
                            children: [
                              Text('Total Amount'),
                              Text('${context.watch<OrderProvider>().totalAmount}'),

                              fluent.NumberFormBox(
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                ]),
                                */ /* inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'), allow: true),
                        ],*/ /*
                                min: 0,
                                max: context.read<OrderProvider>().totalAmount,
                                value: numberBoxValue,
                                onChanged: (value) {
                                  setState(() {
                                    numberBoxValue = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // note field
                              FormBuilderTextField(
                                name: 'note',
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Note (Optional)',
                                  hintText: 'Note for cooker ...',
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Step(
                    state: StepState.complete,
                    isActive: currentStep >= 5,
                    title: const Text('Confirm Order'),
                    content: Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: context.watch<OrderProvider>().cartList.isNotEmpty
                            ? Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        */ /* Text('Customer'),
                                Text(
                                    '${lstCustomers.firstWhere((element) => element.id == _formKeyCustomer.currentState!.fields['customer_id']!.value).fName} ${lstCustomers.firstWhere((element) => element.id == _formKeyCustomer.currentState!.fields['customer_id']!.value).lName}'),
                                Text('Order Date & Time'),
                                Text(
                                    '${_formKeyDateTime.currentState!.fields['order_date']!.value} ${_formKeyDateTime.currentState!.fields['order_time']!.value}'),*/ /*
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: List.generate(context.watch<OrderProvider>().cartList.length, (index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text('${context.watch<OrderProvider>().cartList[index].product.name}'),
                                            subtitle: Text('${context.watch<OrderProvider>().cartList[index].product.price}'),
                                            trailing: Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('x${context.watch<OrderProvider>().cartList[index].quantity}'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 10,
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      tileColor: Colors.grey[200],
                                      title: Text('Total'),
                                      trailing: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('${context.watch<OrderProvider>().totalAmount}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'No item added\nPlease add item first',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )*/
      /*floatingActionButton: currentStep == 2
          ? FloatingActionButton(
              onPressed: () async {
                List<ProductModel> filteredProducts = lstProducts.where((element) => !context.read<OrderProvider>().cartList.map((e) => e.product.id).contains(element.id)).toList();

                await showDialog<bool>(
                  context: context,
                  builder: (context) => fluent.ContentDialog(
                    constraints: BoxConstraints(maxWidth: 400, maxHeight: MediaQuery.of(context).size.height * 0.8),
                    title: Row(children: [
                      Expanded(
                        child: const Text('Add Item to cart'),
                      ),
                      fluent.IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(fluent.FluentIcons.clear),
                      ),
                    ]),
                    content: fluent.Column(
                      children: [
                        fluent.TextBox(),
                        fluent.Expanded(
                            child: fluent.ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return fluent.ListTile.selectable(
                              selected: context.watch<OrderProvider>().selectedProductAddId == filteredProducts[index].id,
                              leading: fluent.Container(
                                child: fluent.Image(
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox();
                                  },
                                  image: NetworkImage(filteredProducts[index].imageUrl),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              title: Text(filteredProducts[index].name),
                              subtitle: Text(filteredProducts[index].price.toString()),
                              onPressed: () {
                                setState(() {
                                  context.read<OrderProvider>().setSelectedProductAddId(filteredProducts[index].id);
                                });
                              },
                            );
                          },
                        )),
                      ],
                    ),
                    actions: [
                      fluent.Container(
                        child: fluent.Row(
                          children: [
                            fluent.Button(
                              child: const Icon(fluent.FluentIcons.add),
                              onPressed: () {
                                context.read<OrderProvider>().incrementOrderQty();
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              context.watch<OrderProvider>().orderQty.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            fluent.Button(
                              child: const Icon(fluent.FluentIcons.remove),
                              onPressed: () {
                                context.read<OrderProvider>().decrementOrderQty();
                              },
                            ),
                          ],
                        ),
                      ),
                      fluent.FilledButton(
                        child: const Text('Confirm'),
                        onPressed: () {
                          context.read<OrderProvider>().addCartList(
                                CartModel(
                                  isDone: false,
                                  product: lstProducts.firstWhere((element) => element.id == context.read<OrderProvider>().selectedProductAddId),
                                  quantity: context.read<OrderProvider>().orderQty,
                                ),
                              );
                          context.read<OrderProvider>().setSelectedProductAddId(null);
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Icon(Icons.add_shopping_cart),
            )
          : null,*/
    );
  }
}
