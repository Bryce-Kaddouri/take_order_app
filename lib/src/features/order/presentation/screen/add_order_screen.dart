import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
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
        controller: stepScrollController,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        onStepContinue: () {
          print(currentStep);
          if (currentStep < 2) {
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
            }
          }
        },
        type: StepperType.horizontal,
        currentStep: currentStep,
        steps: <Step>[
          Step(
            title: const Text('Customer Detail'),
            content: Container(
              color: Colors.red,
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: FormBuilder(
                key: _formKeyCustomer,
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      decoration: InputDecoration(
                        labelText: 'Customer',
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
            title: const Text('Date & Time'),
            content: Container(
              color: Colors.blue,
              height: 500,
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
            title: const Text('Fill Order'),
            content: Container(
              color: Colors.yellow,
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: ListView.builder(
                  itemCount: context.watch<OrderProvider>().cartList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${context.watch<OrderProvider>().cartList[index].product.name}'),
                      subtitle: Text(
                          '${context.watch<OrderProvider>().cartList[index].product.price}'),
                      trailing: Text(
                          '${context.watch<OrderProvider>().cartList[index].quantity}'),
                    );
                  },
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
