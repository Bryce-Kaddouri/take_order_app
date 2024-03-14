import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:take_order_app/src/features/product/presentation/provider/product_provider.dart';

import '../../../cart/data/model/cart_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../product/data/model/product_model.dart';
import '../../data/model/place_order_model.dart';
import '../provider/order_provider.dart';
import '../widget/custom_stepper_widget.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _animationControllerProgressBar;

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
  PageController pageController = PageController();
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (mounted) {
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
    });
    pageController.addListener(() {
      setState(() {
        currentStep = pageController.page!.round();
      });
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationControllerProgressBar = AnimationController(vsync: this, duration: Duration(milliseconds: 3300), lowerBound: 0, upperBound: 11);
    _animationControllerProgressBar.animateTo(1.5);
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
    return material.Scaffold(
      backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: material.AppBar(
        leading: currentStep == 0
            ? material.BackButton(
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
              )
            : null,
        centerTitle: true,
        shadowColor: FluentTheme.of(context).shadowColor,
        surfaceTintColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        elevation: 4,
        title: Text(getTitle(currentStep)),
      ),
      bottomNavigationBar: currentStep >= 5
          ? null
          : Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 30,
                        child: Row(
                          children: [
                            Icon(FluentIcons.back),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Back')
                          ],
                        ),
                      ),
                      onPressed: currentStep == 0
                          ? null
                          : () {
                              if (currentStep > 0) {
                                pageController.animateToPage(currentStep - 1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                if (currentStep == 1) {
                                  _animationControllerProgressBar.animateTo(1.5);
                                } else if (currentStep == 2) {
                                  _animationControllerProgressBar.animateTo(3.5);
                                } else if (currentStep == 3) {
                                  _animationControllerProgressBar.animateTo(5.5);
                                } else if (currentStep == 4) {
                                  _animationControllerProgressBar.animateTo(7.5);
                                }
                              }
                            }),
                  if (currentStep == 2)
                    FilledButton(
                      onPressed: () async {
                        List<ProductModel> filteredProducts = lstProducts.where((element) => !context.read<OrderProvider>().cartList.map((e) => e.product.id).contains(element.id)).toList();

                        await showDialog<bool>(
                          context: context,
                          builder: (context) => ContentDialog(
                            constraints: BoxConstraints(maxWidth: 400, maxHeight: MediaQuery.of(context).size.height * 0.8),
                            title: Row(children: [
                              Expanded(
                                child: const Text('Add Item to cart'),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(FluentIcons.clear),
                              ),
                            ]),
                            content: Column(
                              children: [
                                TextBox(),
                                Expanded(
                                    child: ListView.builder(
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    return ListTile.selectable(
                                      selected: context.watch<OrderProvider>().selectedProductAddId == filteredProducts[index].id,
                                      leading: Container(
                                        child: Image(
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
                              Container(
                                child: Row(
                                  children: [
                                    Button(
                                      child: const Icon(FluentIcons.add),
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
                                    Button(
                                      child: const Icon(FluentIcons.remove),
                                      onPressed: () {
                                        context.read<OrderProvider>().decrementOrderQty();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              FilledButton(
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
                      child: Container(
                        padding: EdgeInsets.all(0),
                        height: 40,
                        width: 40,
                        child: Icon(
                          FluentIcons.circle_addition,
                          size: 30,
                        ),
                      ),
                    ),
                  Button(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 30,
                        child: Row(
                          children: [
                            Icon(FluentIcons.forward),
                            SizedBox(
                              width: 10,
                            ),
                            Text(currentStep == 4 ? 'Place Order' : 'Next')
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
                            _animationControllerProgressBar.animateTo(3.5);
                          }
                        } else if (currentStep == 1) {
                          pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                          _animationControllerProgressBar.animateTo(5.5);
                        } else if (currentStep == 2) {
                          if (context.read<OrderProvider>().cartList.isNotEmpty) {
                            pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                            _animationControllerProgressBar.animateTo(7.5);
                          } else {
                            displayInfoBar(alignment: Alignment.topRight, context, builder: (context, close) {
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
                        } else if (currentStep == 3) {
                          if (_fromKeyPayment.currentState!.validate()) {
                            pageController.animateToPage(4, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                            _animationControllerProgressBar.animateTo(9.5);
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
                            orderTime: material.TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute),
                          );

                          context.read<OrderProvider>().placeOrder(placeOrderModel).then((value) {
                            if (value) {
                              _animationControllerProgressBar.animateTo(11);
                              pageController.animateToPage(5, duration: Duration(milliseconds: 300), curve: Curves.easeIn).whenComplete(() => _animationController.forward());
                            } else {
                              displayInfoBar(alignment: Alignment.topRight, context, builder: (context, close) {
                                return InfoBar(
                                  title: const Text('Error!'),
                                  content: const Text('Error placing order'),
                                  severity: InfoBarSeverity.error,
                                  action: IconButton(
                                    icon: const Icon(FluentIcons.clear),
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
      body: Column(
        children: [
          CustomStepperWidget(
            currentStep: currentStep,
            controller: _animationControllerProgressBar,
          ),
          Expanded(
            child: PageView(controller: pageController, children: [
              // page for customer
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKeyCustomer,
                  child: Column(
                    children: [
                      AutoSuggestBox.form(
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

                          /*if (reason == TextChangedReason.suggestionChosen) {
                            setState(() {
                              selectedCustomerId = int.parse(value);
                            });
                          }*/
                        },
                        placeholder: 'Select Customer',
                        items: List.generate(
                          lstCustomers.length,
                          (index) => AutoSuggestBoxItem<int>(label: '${lstCustomers[index].fName} ${lstCustomers[index].lName}', value: lstCustomers[index].id),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // page for date and time
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    DatePicker(
                      header: 'Pick a date',
                      selected: selectedDate,
                      onChanged: (time) {
                        setState(() {
                          selectedDate = selectedDate.copyWith(year: time.year, month: time.month, day: time.day);
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TimePicker(
                      selected: selectedDate,
                      onChanged: (DateTime time) {
                        setState(() {
                          selectedDate = selectedDate.copyWith(hour: time.hour, minute: time.minute);
                        });
                      },
                      hourFormat: HourFormat.HH,
                    ),
                  ],
                ),
              ),
              // page for fill order
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: context.watch<OrderProvider>().cartList.isNotEmpty
                      ? Column(children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: context.watch<OrderProvider>().cartList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    leading: Container(
                                      child: Image(
                                        errorBuilder: (context, error, stackTrace) {
                                          return SizedBox();
                                        },
                                        image: NetworkImage(context.watch<OrderProvider>().cartList[index].product.imageUrl),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
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
                                            icon: Icon(FluentIcons.remove),
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
                                            icon: Icon(FluentIcons.add),
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
                                        builder: (context) => ContentDialog(
                                          constraints: BoxConstraints(maxWidth: 400, maxHeight: MediaQuery.of(context).size.height * 0.8),
                                          title: Container(
                                            alignment: Alignment.center,
                                            child: const Text('Edit Quantity'),
                                          ),
                                          content: Column(
                                            children: [
                                              Form(
                                                key: _formKeyQty,
                                                child: NumberFormBox<int>(
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
                                            Button(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FilledButton(
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
                          Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Amount'),
                                Text(context.watch<OrderProvider>().totalAmount.toString()),
                              ],
                            ),
                          ),
                        ])
                      : Center(
                          child: Text(
                            'No item added\nPlease add item first',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                ),
              ),
              // page for payment
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _fromKeyPayment,
                  child: Column(
                    children: [
                      InfoLabel(
                        label: 'Payment Amount:',
                        child: NumberFormBox<double>(
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
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InfoLabel(
                              label: 'Note:',
                              child: TextFormBox(
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
                            Container(
                              child: RichText(
                                text: TextSpan(
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
                      Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount'),
                            Text(context.watch<OrderProvider>().totalAmount.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // page for review

              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            // rounded rectanmgle
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Icon(FluentIcons.date_time),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text('${DateHelper.getFormattedDateTime(selectedDate)}'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (selectedCustomerId != -1)
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(FluentIcons.contact),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text('${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).fName} ${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).lName}'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(FluentIcons.phone),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).countryCode}${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).phoneNumber}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: context.watch<OrderProvider>().cartList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              leading: Container(
                                child: Image(
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox();
                                  },
                                  image: NetworkImage(context.watch<OrderProvider>().cartList[index].product.imageUrl),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              title: Text('${context.watch<OrderProvider>().cartList[index].product.name}'),
                              subtitle: Text('${context.watch<OrderProvider>().cartList[index].product.price}'),
                              trailing: Text(context.watch<OrderProvider>().cartList[index].quantity.toString()),
                            );
                          }),
                    ),
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount'),
                          Text(context.watch<OrderProvider>().totalAmount.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // success page
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // animated icon
                    AnimatedBuilder(
                      animation: _animation,
                      child: Icon(
                        FluentIcons.skype_circle_check,
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
                      child: FilledButton(
                        onPressed: () {
                          /*context.go('/orders');*/
                          Navigator.pop(context);
                        },
                        child: Text('Go to Orders'),
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
