import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:take_order_app/src/features/product/presentation/provider/product_provider.dart';

import '../../../cart/data/model/cart_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../product/data/model/product_model.dart';
import '../../data/model/place_order_model.dart';
import '../provider/order_provider.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> with fluent.TickerProviderStateMixin {
  late fluent.AnimationController _animationController;
  late fluent.Animation<double> _animation;
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
  fluent.PageController pageController = fluent.PageController();
  // controller for customer
  final TextEditingController customerController = TextEditingController();
  int selectedCustomerIndex = -1;
  // controller for payment amount
  double _paymentAmount = 0.0;
  // controller for note
  final TextEditingController _noteController = TextEditingController();

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
    pageController.addListener(() {
      setState(() {
        currentStep = pageController.page!.round();
      });
    });

    _animationController = fluent.AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = fluent.CurvedAnimation(
      parent: _animationController,
      curve: fluent.Curves.easeIn,
    );
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
        return 'Payment Detail';
      case 4:
        return 'Review Order';
      case 5:
        return 'Order Placed Successfully';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    stepScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return fluent.ScaffoldPage(
      header: fluent.PageHeader(
        title: Text(getTitle(currentStep)),
      ),
      bottomBar: currentStep >= 5
          ? null
          : fluent.Card(
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
                                pageController.animateToPage(int.parse(pageController.page.toString()) - 1, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                              }
                            }),
                  if (currentStep == 2)
                    fluent.FilledButton(
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
                      child: fluent.Container(
                        padding: EdgeInsets.all(0),
                        height: 40,
                        width: 40,
                        child: fluent.Icon(
                          fluent.FluentIcons.circle_addition,
                          size: 30,
                        ),
                      ),
                    ),
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
                            fluent.Text(currentStep == 4 ? 'Place Order' : 'Next')
                          ],
                        ),
                      ),
                      onPressed: () {
                        print(currentStep);
                        if (currentStep == 0) {
                          if (_formKeyCustomer.currentState!.validate()) {
                            /* setState(() {
                        currentStep += 1;
                      });*/
                            pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                          }
                        } else if (currentStep == 1) {
                          pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        } else if (currentStep == 2) {
                          if (context.read<OrderProvider>().cartList.isNotEmpty) {
                            pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                          } else {
                            fluent.displayInfoBar(alignment: fluent.Alignment.topRight, context, builder: (context, close) {
                              return fluent.InfoBar(
                                title: const Text('Error!'),
                                content: const Text('Please add item first'),
                                severity: fluent.InfoBarSeverity.error,
                                action: IconButton(
                                  icon: const Icon(fluent.FluentIcons.clear),
                                  onPressed: close,
                                ),
                              );
                            });
                          }
                        } else if (currentStep == 3) {
                          if (_fromKeyPayment.currentState!.validate()) {
                            pageController.animateToPage(4, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                          }
                        } else if (currentStep == 4) {
                          List<CartModel> cartList = context.read<OrderProvider>().cartList;
                          CustomerModel customer = lstCustomers.firstWhere((element) => element.id == selectedCustomerId);
                          double paymentAmount = _paymentAmount;
                          DateTime orderDate = selectedDate;
                          String note = _noteController.text;
                          print(cartList);
                          print(customer);
                          print(paymentAmount);
                          print(orderDate);
                          print(note);

                          PlaceOrderModel placeOrderModel = PlaceOrderModel(
                            cartList: cartList,
                            customer: customer,
                            paymentAmount: paymentAmount,
                            orderDate: selectedDate,
                            note: note.isEmpty ? null : note,
                            orderTime: TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute),
                          );

                          context.read<OrderProvider>().placeOrder(placeOrderModel).then((value) {
                            if (value) {
                              pageController.animateToPage(5, duration: Duration(milliseconds: 300), curve: Curves.easeIn).whenComplete(() => _animationController.forward());
                            } else {
                              fluent.displayInfoBar(alignment: fluent.Alignment.topRight, context, builder: (context, close) {
                                return fluent.InfoBar(
                                  title: const Text('Error!'),
                                  content: const Text('Error placing order'),
                                  severity: fluent.InfoBarSeverity.error,
                                  action: IconButton(
                                    icon: const Icon(fluent.FluentIcons.clear),
                                    onPressed: close,
                                  ),
                                );
                              });
                            }
                          });
                        }
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
            child: fluent.PageView(controller: pageController, children: [
              // page for customer
              fluent.Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: fluent.Form(
                  key: _formKeyCustomer,
                  child: fluent.Column(
                    children: [
                      fluent.AutoSuggestBox.form(
                        controller: customerController,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        onSelected: (value) {
                          setState(() {
                            selectedCustomerId = value.value!;
                          });
                        },
                        onChanged: (value, reason) {
                          print(value);
                          print(reason);
                          print(customerController.text);

                          /*if (reason == fluent.TextChangedReason.suggestionChosen) {
                            setState(() {
                              selectedCustomerId = int.parse(value);
                            });
                          }*/
                        },
                        placeholder: 'Select Customer',
                        items: List.generate(
                          lstCustomers.length,
                          (index) => fluent.AutoSuggestBoxItem<int>(label: '${lstCustomers[index].fName} ${lstCustomers[index].lName}', value: lstCustomers[index].id),
                        ),
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
                      selected: selectedDate,
                      onChanged: (time) {
                        setState(() {
                          selectedDate = selectedDate.copyWith(year: time.year, month: time.month, day: time.day);
                        });
                      },
                    ),
                    fluent.SizedBox(
                      height: 10,
                    ),
                    fluent.TimePicker(
                      selected: selectedDate,
                      onChanged: (DateTime time) {
                        setState(() {
                          selectedDate = selectedDate.copyWith(hour: time.hour, minute: time.minute);
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
                      ? fluent.Column(children: [
                          fluent.Expanded(
                            child: fluent.ListView.builder(
                                itemCount: context.watch<OrderProvider>().cartList.length,
                                itemBuilder: (context, index) {
                                  return fluent.ListTile(
                                    shape: fluent.RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    leading: fluent.Container(
                                      child: fluent.Image(
                                        errorBuilder: (context, error, stackTrace) {
                                          return SizedBox();
                                        },
                                        image: NetworkImage(context.watch<OrderProvider>().cartList[index].product.imageUrl),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
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
                                    onPressed: () async {
                                      // global key for form builder
                                      final _formKeyQty = GlobalKey<FormState>();
                                      int qty = context.read<OrderProvider>().cartList[index].quantity;

                                      await showDialog<bool>(
                                        context: context,
                                        builder: (context) => fluent.ContentDialog(
                                          constraints: BoxConstraints(maxWidth: 400, maxHeight: MediaQuery.of(context).size.height * 0.8),
                                          title: fluent.Container(
                                            alignment: Alignment.center,
                                            child: const Text('Edit Quantity'),
                                          ),
                                          content: fluent.Column(
                                            children: [
                                              fluent.Form(
                                                key: _formKeyQty,
                                                child: fluent.NumberFormBox<int>(
                                                  onChanged: (value) {
                                                    setState(() {
                                                      qty = value!;
                                                    });
                                                  },
                                                  value: qty,
                                                  placeholder: 'Quantity',
                                                  min: 0,
                                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                  validator: FormBuilderValidators.compose([
                                                    FormBuilderValidators.required(),
                                                    FormBuilderValidators.integer(),
                                                    FormBuilderValidators.min(1, errorText: 'Quantity must be greater than 0'),
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            fluent.Button(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            fluent.FilledButton(
                                              child: const Text('Confirm'),
                                              onPressed: () {
                                                if (_formKeyQty.currentState!.validate()) {
                                                  context.read<OrderProvider>().updateQuantityCartList(index, qty);
                                                  Navigator.pop(context);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ),
                          fluent.Card(
                            child: fluent.Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                fluent.Text('Total Amount'),
                                fluent.Text(context.watch<OrderProvider>().totalAmount.toString()),
                              ],
                            ),
                          ),
                        ])
                      : fluent.Center(
                          child: fluent.Text(
                            'No item added\nPlease add item first',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                ),
              ),
              // page for payment
              fluent.Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: fluent.Form(
                  key: _fromKeyPayment,
                  child: fluent.Column(
                    children: [
                      fluent.InfoLabel(
                        label: 'Payment Amount:',
                        child: fluent.NumberFormBox<double>(
                          onChanged: (value) {
                            setState(() {
                              _paymentAmount = value!;
                            });
                          },
                          value: _paymentAmount,
                          placeholder: 'Payment Amount',
                          min: 0,
                          max: context.watch<OrderProvider>().totalAmount,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(0, errorText: 'Payment amount must be greater than 0'),
                          ]),
                        ),
                      ),
                      fluent.SizedBox(
                        height: 20,
                      ),
                      fluent.Expanded(
                        child: fluent.Column(
                          children: [
                            fluent.InfoLabel(
                              label: 'Note:',
                              child: fluent.TextFormBox(
                                onChanged: (value) {
                                  setState(() {});
                                },
                                maxLength: 200,
                                controller: _noteController,
                                placeholder: 'Note ...',
                                minLines: 3,
                                maxLines: 6,
                              ),
                            ),
                            fluent.Container(
                              child: fluent.RichText(
                                text: fluent.TextSpan(
                                  text: _noteController.text.length.toString(),
                                  style: TextStyle(
                                    color: _noteController.text.length > 200 ? Colors.red : Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '/200',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      fluent.Card(
                        child: fluent.Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            fluent.Text('Total Amount'),
                            fluent.Text(context.watch<OrderProvider>().totalAmount.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // page for review

              fluent.Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: fluent.Column(
                  children: [
                    fluent.Row(
                      children: [
                        fluent.Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            // rounded rectanmgle
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: fluent.Icon(fluent.FluentIcons.date_time),
                        ),
                        fluent.SizedBox(
                          width: 10,
                        ),
                        fluent.Expanded(
                          child: fluent.Text('${DateHelper.getFormattedDateTime(selectedDate)}'),
                        ),
                      ],
                    ),
                    fluent.SizedBox(
                      height: 10,
                    ),
                    if (selectedCustomerId != -1)
                      fluent.Row(
                        children: [
                          fluent.Expanded(
                            child: fluent.Row(
                              children: [
                                fluent.Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: fluent.Icon(fluent.FluentIcons.contact),
                                ),
                                fluent.SizedBox(
                                  width: 10,
                                ),
                                fluent.Expanded(
                                  child: fluent.Text('${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).fName} ${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).lName}'),
                                ),
                              ],
                            ),
                          ),
                          fluent.Expanded(
                            child: fluent.Row(
                              children: [
                                fluent.Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: fluent.Icon(fluent.FluentIcons.phone),
                                ),
                                fluent.SizedBox(
                                  width: 10,
                                ),
                                fluent.Text('${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).countryCode}${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).phoneNumber}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    fluent.SizedBox(
                      height: 10,
                    ),
                    fluent.Expanded(
                      child: fluent.ListView.builder(
                          itemCount: context.watch<OrderProvider>().cartList.length,
                          itemBuilder: (context, index) {
                            return fluent.ListTile(
                              shape: fluent.RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              leading: fluent.Container(
                                child: fluent.Image(
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox();
                                  },
                                  image: NetworkImage(context.watch<OrderProvider>().cartList[index].product.imageUrl),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              title: fluent.Text('${context.watch<OrderProvider>().cartList[index].product.name}'),
                              subtitle: fluent.Text('${context.watch<OrderProvider>().cartList[index].product.price}'),
                              trailing: fluent.Text(context.watch<OrderProvider>().cartList[index].quantity.toString()),
                            );
                          }),
                    ),
                    fluent.Card(
                      child: fluent.Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fluent.Text('Total Amount'),
                          fluent.Text(context.watch<OrderProvider>().totalAmount.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // success page
              fluent.Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: fluent.Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // animated icon
                    AnimatedBuilder(
                      animation: _animation,
                      child: fluent.Icon(
                        fluent.FluentIcons.skype_circle_check,
                        size: 200,
                        color: Colors.green,
                      ),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: child,
                        );
                      },
                    ),
                    Text(
                      'Order has been placed successfully',
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      width: 300,
                      height: 50,
                      child: fluent.FilledButton(
                        onPressed: () {
                          /*context.go('/orders');*/
                          Navigator.pop(context);
                        },
                        child: fluent.Text('Go to Orders'),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
