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
          if (currentStep < 4) {
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
              setState(() {
                currentStep += 1;
              });
            } else if (currentStep == 3) {
              setState(() {
                currentStep += 1;
              });
            } else if (currentStep == 4) {
              setState(() {
                currentStep += 1;
              });
            }
          }
        },
        type: StepperType.horizontal,
        currentStep: currentStep,
        steps: <Step>[
          Step(
            isActive: currentStep >= 0,
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
            isActive: currentStep >= 1,
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
            isActive: currentStep >= 2,
            title: const Text('Fill Order'),
            content: Container(
              color: Colors.yellow,
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: context.watch<OrderProvider>().cartList.isNotEmpty
                    ? ListView.builder(
                        itemCount:
                            context.watch<OrderProvider>().cartList.length,
                        itemBuilder: (context, index) {
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
                                                            .fields['quantity']!
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.grey[200],
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
              color: Colors.purple,
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: context.watch<OrderProvider>().cartList.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: context
                                  .watch<OrderProvider>()
                                  .cartList
                                  .length,
                              itemBuilder: (context, index) {
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: Colors.grey[200],
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
                          Container(
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
            title: const Text('Confirm Order'),
            content: Container(
              color: Colors.purple,
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: context.watch<OrderProvider>().cartList.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                              child: Container(
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
                          )),
                          Expanded(
                            child: ListView.builder(
                              itemCount: context
                                  .watch<OrderProvider>()
                                  .cartList
                                  .length,
                              itemBuilder: (context, index) {
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    tileColor: Colors.grey[200],
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
                          Container(
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
