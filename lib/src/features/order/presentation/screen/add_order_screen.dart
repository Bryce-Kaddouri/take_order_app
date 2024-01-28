import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/responsive_helper.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:take_order_app/src/features/order/data/model/place_order_model.dart';
import 'package:take_order_app/src/features/order/presentation/provider/order_provider.dart';
import 'package:take_order_app/src/features/product/presentation/provider/product_provider.dart';

import '../../../cart/data/model/cart_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../product/data/model/product_model.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  ScrollController stepScrollController = ScrollController();
  int currentStep = 0;
  final _formKeyCustomer = GlobalKey<FormBuilderState>();
  final _formKeyDateTime = GlobalKey<FormBuilderState>();
  final _fromKeyPayment = GlobalKey<FormBuilderState>();

  List<CustomerModel> lstCustomers = [];
  int selectedCustomerId = -1;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<CustomerProvider>().getCustomers().then((value) {
      setState(() {
        lstCustomers = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
      ),
      body: Stepper(
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
                    List<CartModel> cartList =
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
                    });
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
                        if (_formKeyDateTime.currentState!.validate()) {
                          setState(() {
                            currentStep += 1;
                          });
                        } else {
                          print('invalid');
                        }
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
              if (_formKeyDateTime.currentState!.validate()) {
                setState(() {
                  currentStep += 1;
                });
              } else {
                print('invalid');
              }
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
        type: !ResponsiveHelper.isDesktop(context)
            ? StepperType.vertical
            : StepperType.horizontal,
        currentStep: currentStep,
        steps: <Step>[
          Step(
            isActive: currentStep >= 0,
            title: const Text('Customer Detail'),
            content: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: FormBuilder(
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
              ),
            ),
          ),
          Step(
            isActive: currentStep >= 1,
            title: const Text('Date & Time'),
            content: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: FormBuilder(
                key: _formKeyDateTime,
                child: Column(
                  children: [
                    FormBuilderDateTimePicker(
                      firstDate: selectedDate,
                      initialDate: selectedDate,
                      name: 'order_date',
                      inputType: InputType.date,
                      decoration: InputDecoration(
                        labelText: 'Order Date',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        // check if number
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormBuilderDateTimePicker(
                      firstDate: selectedDate,
                      initialDate: selectedDate,
                      initialTime: TimeOfDay(
                        hour: 11,
                        minute: 30,
                      ),
                      name: 'order_time',
                      inputType: InputType.time,
                      decoration: InputDecoration(
                        labelText: 'Order Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        // check if number
                      ]),
                    ),
                  ],
                ),
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
                                onTap: () {
                                  // global key for form builder
                                  final _formKeyQty =
                                      GlobalKey<FormBuilderState>();
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
                                                if (_formKeyQty.currentState!
                                                    .validate()) {
                                                  context
                                                      .read<OrderProvider>()
                                                      .updateQuantityCartList(
                                                          index,
                                                          int.parse(_formKeyQty
                                                              .currentState!
                                                              .fields[
                                                                  'quantity']!
                                                              .value
                                                              .toString()));
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text('Confirm'),
                                            ),
                                          ],
                                          title: Text('Edit Quantity'),
                                          content: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: 100,
                                            child: FormBuilder(
                                              key: _formKeyQty,
                                              child: Column(
                                                children: [
                                                  FormBuilderTextField(
                                                    initialValue: context
                                                        .watch<OrderProvider>()
                                                        .cartList[index]
                                                        .quantity
                                                        .toString(),
                                                    autofocus: true,
                                                    name: 'quantity',
                                                    decoration: InputDecoration(
                                                      labelText: 'Quantity',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    validator:
                                                        FormBuilderValidators
                                                            .compose([
                                                      FormBuilderValidators
                                                          .required(),
                                                      FormBuilderValidators
                                                          .numeric(),
                                                      // check > 0
                                                      FormBuilderValidators.min(
                                                          1),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                title: Text(
                                    '${context.watch<OrderProvider>().cartList[index].product.name}'),
                                subtitle: Text(
                                    '${context.watch<OrderProvider>().cartList[index].product.price}'),
                                trailing: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          int currentQty = context
                                              .read<OrderProvider>()
                                              .cartList[index]
                                              .quantity;
                                          if (currentQty > 1) {
                                            context
                                                .read<OrderProvider>()
                                                .updateQuantityCartList(
                                                    index, currentQty - 1);
                                          } else {
                                            context
                                                .read<OrderProvider>()
                                                .removeCartList(context
                                                    .read<OrderProvider>()
                                                    .cartList[index]);
                                          }
                                        },
                                        icon: Icon(Icons.remove),
                                      ),
                                      Text(
                                          context
                                              .watch<OrderProvider>()
                                              .cartList[index]
                                              .quantity
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      IconButton(
                                        onPressed: () {
                                          int currentQty = context
                                              .read<OrderProvider>()
                                              .cartList[index]
                                              .quantity;
                                          context
                                              .read<OrderProvider>()
                                              .updateQuantityCartList(
                                                  index, currentQty + 1);
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
                                      title: Text(
                                          '${context.watch<OrderProvider>().cartList[index].product.name}'),
                                      subtitle: Text(
                                          '${context.watch<OrderProvider>().cartList[index].product.price}'),
                                      trailing: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                'x${context.watch<OrderProvider>().cartList[index].quantity}'),
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
                                    Text(
                                        '${context.watch<OrderProvider>().totalAmount}'),
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
                child: FormBuilder(
                  key: _fromKeyPayment,
                  child: Column(
                    children: [
                      Text('Total Amount'),
                      Text('${context.watch<OrderProvider>().totalAmount}'),
                      FormBuilderTextField(
                        name: 'payment_amount',
                        decoration: InputDecoration(
                          labelText: 'Payment Amount',
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'),
                              allow: true),
                        ],
                        initialValue: context
                            .watch<OrderProvider>()
                            .totalAmount
                            .toString(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
/*
                          FormBuilderValidators.numeric(),
*/
                          // check if number
                        ]),
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
                                Text('Customer'),
                                Text(
                                    '${lstCustomers.firstWhere((element) => element.id == _formKeyCustomer.currentState!.fields['customer_id']!.value).fName} ${lstCustomers.firstWhere((element) => element.id == _formKeyCustomer.currentState!.fields['customer_id']!.value).lName}'),
                                Text('Order Date & Time'),
                                Text(
                                    '${_formKeyDateTime.currentState!.fields['order_date']!.value} ${_formKeyDateTime.currentState!.fields['order_time']!.value}'),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: List.generate(
                                  context
                                      .watch<OrderProvider>()
                                      .cartList
                                      .length, (index) {
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
                                    title: Text(
                                        '${context.watch<OrderProvider>().cartList[index].product.name}'),
                                    subtitle: Text(
                                        '${context.watch<OrderProvider>().cartList[index].product.price}'),
                                    trailing: Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              'x${context.watch<OrderProvider>().cartList[index].quantity}'),
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
                                    Text(
                                        '${context.watch<OrderProvider>().totalAmount}'),
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
      floatingActionButton: currentStep == 2
          ? FloatingActionButton(
              onPressed: () async {
                await showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController searchController =
                          TextEditingController();
                      Stream<String> streamSearch = Stream.periodic(
                          Duration(milliseconds: 500),
                          (x) => searchController.text);

                      return AlertDialog(
                        actions: [
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<OrderProvider>()
                                        .decrementOrderQty();
                                  },
                                  icon: Icon(Icons.remove),
                                ),
                                Text(
                                    context
                                        .watch<OrderProvider>()
                                        .orderQty
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<OrderProvider>()
                                        .incrementOrderQty();
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<OrderProvider>().clearCartList();

                              // close dialog
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<OrderProvider>().addCartList(
                                    CartModel(
                                      isDone: false,
                                      product: context
                                          .read<OrderProvider>()
                                          .selectedProduct!,
                                      quantity: context
                                          .read<OrderProvider>()
                                          .orderQty,
                                    ),
                                  );
                              // reset selected product and order qty
                              context.read<OrderProvider>().setSelectedProduct(
                                    null,
                                  );
                              context.read<OrderProvider>().setOrderQty(1);
                              // close dialog
                              Navigator.pop(context);
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                        title: Text('Add Item'),
                        content: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: StreamBuilder(
                              stream: streamSearch,
                              builder: (context, snapshotSearch) {
                                if (snapshotSearch.hasData) {
                                  print(snapshotSearch.data);

                                  return FutureBuilder(
                                    future: context
                                        .read<ProductProvider>()
                                        .getProducts(),
                                    builder: (context, snapshot) {
                                      String search = '';
                                      if (snapshot.hasData) {
                                        List<ProductModel> lstProduct =
                                            snapshot.data as List<ProductModel>;

                                        // remove where product is already in cart
                                        lstProduct = lstProduct
                                            .where((element) => !context
                                                .read<OrderProvider>()
                                                .cartList
                                                .map((e) => e.product.id)
                                                .toList()
                                                .contains(element.id))
                                            .toList();

                                        lstProduct = lstProduct
                                            .where((element) => element.name
                                                .toLowerCase()
                                                .contains(snapshotSearch.data
                                                    .toString()
                                                    .toLowerCase()))
                                            .toList();

                                        print(lstProduct.length);
                                        return Column(
                                          children: [
                                            Container(
                                              height: 50,
                                              child: TextField(
                                                controller: searchController,
                                                onChanged: (value) {
                                                  setState(() {
                                                    search = value;
                                                  });

                                                  print(search);
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Search',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            if (lstProduct.length == 0)
                                              Center(
                                                child: Text('No product found'),
                                              )
                                            else
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: lstProduct.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      selected: context
                                                              .watch<
                                                                  OrderProvider>()
                                                              .selectedProduct
                                                              ?.id ==
                                                          lstProduct[index].id,
                                                      onTap: () {
                                                        setState(() {
                                                          context
                                                              .read<
                                                                  OrderProvider>()
                                                              .setSelectedProduct(
                                                                  lstProduct[
                                                                      index]);
                                                        });
                                                      },
                                                      title: Text(
                                                          '${lstProduct[index].name}'),
                                                      subtitle: Text(
                                                          '${lstProduct[index].price}'),
                                                    );
                                                  },
                                                ),
                                              ),
                                          ],
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    });
              },
              child: Icon(Icons.add_shopping_cart),
            )
          : null,
    );
  }
}
