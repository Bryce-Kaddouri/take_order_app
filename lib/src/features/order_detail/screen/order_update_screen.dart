import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:take_order_app/src/features/order/data/model/order_model.dart';
import 'package:take_order_app/src/features/product/presentation/provider/product_provider.dart';

import '../../auth/presentation/provider/auth_provider.dart';
import '../../cart/data/model/cart_model.dart';
import '../../customer/data/model/customer_model.dart';
import '../../order/presentation/provider/order_provider.dart';
import '../../order/presentation/widget/custom_stepper_widget.dart';
import '../../product/data/model/product_model.dart';
import '../business/param.dart';

class OrderUpdateScreen extends StatefulWidget {
  int orderId;
  DateTime orderDate;

  OrderUpdateScreen(
      {super.key, required this.orderId, required this.orderDate});
  @override
  State<OrderUpdateScreen> createState() => _OrderUpdateScreenState();
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen>
    with fluent.TickerProviderStateMixin {
  late fluent.AnimationController _animationController;
  late fluent.Animation<double> _animation;
  late fluent.AnimationController _animationControllerProgressBar;

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
  List<CartModel> oldCartList = [];
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
  OrderModel? orderModel;

  @override
  void initState() {
    super.initState();
    fluent.WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
        context
            .read<OrderProvider>()
            .getOrderDetail(widget.orderId, widget.orderDate)
            .then((value) {
          setState(() {
            orderModel = value;
            oldCartList = value!.cart;
            print(value!.cart);
            // init customerController
            customerController.text =
                '${orderModel!.customer.fName} ${orderModel!.customer.lName}';
            selectedCustomerId = orderModel!.customer.id!;
            // init selected date
            selectedDate = orderModel!.date.copyWith(
                hour: orderModel!.time.hour, minute: orderModel!.time.minute);
            // init cart list
            context.read<OrderProvider>().setCartList(orderModel!.cart);
            print('init cart list');

            // init payment amount
            _paymentAmount = orderModel!.paidAmount;
            // init note
            _noteController.text = orderModel!.orderNote;
          });
        });
      }
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

    _animationControllerProgressBar = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 3300),
        lowerBound: 0,
        upperBound: 11);
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
    return orderModel == null
        ? fluent.ScaffoldPage(
            header: fluent.PageHeader(
              title: Text('Loading...'),
            ),
            content: fluent.Center(
              child: fluent.ProgressRing(),
            ),
          )
        : fluent.ScaffoldPage(
            padding: EdgeInsets.all(0),
            header: fluent.PageHeader(
              leading: currentStep != 0
                  ? null
                  : fluent.Row(
                      children: [
                        fluent.SizedBox(
                          width: 10,
                        ),
                        fluent.FilledButton(
                          style: fluent.ButtonStyle(
                            padding: fluent.ButtonState.all(EdgeInsets.all(0)),
                          ),
                          onPressed: () {
                            String date =
                                DateHelper.getFormattedDate(widget.orderDate);
                            context.go('/orders/$date/${widget.orderId}');
                          },
                          child: fluent.Container(
                            padding: EdgeInsets.all(0),
                            height: 40,
                            width: 40,
                            child: fluent.Icon(
                              fluent.FluentIcons.back,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
              title: fluent.Container(
                height: 40,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(getTitle(currentStep)),
              ),
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
                                      pageController.animateToPage(
                                          int.parse(pageController.page
                                                  .toString()) -
                                              1,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn);
                                      if (currentStep == 1) {
                                        _animationControllerProgressBar
                                            .animateTo(1.5);
                                      } else if (currentStep == 2) {
                                        _animationControllerProgressBar
                                            .animateTo(3.5);
                                      } else if (currentStep == 3) {
                                        _animationControllerProgressBar
                                            .animateTo(5.5);
                                      } else if (currentStep == 4) {
                                        _animationControllerProgressBar
                                            .animateTo(7.5);
                                      }
                                    }
                                  }),
                        if (currentStep == 2)
                          fluent.FilledButton(
                            onPressed: () async {
                              List<ProductModel> filteredProducts = lstProducts
                                  .where((element) => !context
                                      .read<OrderProvider>()
                                      .cartList
                                      .map((e) => e.product.id)
                                      .contains(element.id))
                                  .toList();

                              await showDialog<bool>(
                                context: context,
                                builder: (context) => fluent.ContentDialog(
                                  constraints: BoxConstraints(
                                      maxWidth: 400,
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.8),
                                  title: Row(children: [
                                    Expanded(
                                      child: const Text('Add Item to cart'),
                                    ),
                                    fluent.IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon:
                                          const Icon(fluent.FluentIcons.clear),
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
                                            selected: context
                                                    .watch<OrderProvider>()
                                                    .selectedProductAddId ==
                                                filteredProducts[index].id,
                                            leading: fluent.Container(
                                              child: fluent.Image(
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return SizedBox();
                                                },
                                                image: NetworkImage(
                                                    filteredProducts[index]
                                                        .imageUrl),
                                                width: 50,
                                                height: 50,
                                              ),
                                            ),
                                            title: Text(
                                                filteredProducts[index].name),
                                            subtitle: Text(
                                                filteredProducts[index]
                                                    .price
                                                    .toString()),
                                            onPressed: () {
                                              setState(() {
                                                context
                                                    .read<OrderProvider>()
                                                    .setSelectedProductAddId(
                                                        filteredProducts[index]
                                                            .id);
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
                                            child: const Icon(
                                                fluent.FluentIcons.add),
                                            onPressed: () {
                                              context
                                                  .read<OrderProvider>()
                                                  .incrementOrderQty();
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            context
                                                .watch<OrderProvider>()
                                                .orderQty
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          fluent.Button(
                                            child: const Icon(
                                                fluent.FluentIcons.remove),
                                            onPressed: () {
                                              context
                                                  .read<OrderProvider>()
                                                  .decrementOrderQty();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    fluent.FilledButton(
                                      child: const Text('Confirm'),
                                      onPressed: () {
                                        context
                                            .read<OrderProvider>()
                                            .addCartList(
                                              CartModel(
                                                isDone: false,
                                                product: lstProducts.firstWhere(
                                                    (element) =>
                                                        element.id ==
                                                        context
                                                            .read<
                                                                OrderProvider>()
                                                            .selectedProductAddId),
                                                quantity: context
                                                    .read<OrderProvider>()
                                                    .orderQty,
                                              ),
                                            );
                                        context
                                            .read<OrderProvider>()
                                            .setSelectedProductAddId(null);
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
                                  fluent.Text(
                                      currentStep == 4 ? 'Place Order' : 'Next')
                                ],
                              ),
                            ),
                            onPressed: () async {
                              print(currentStep);
                              if (currentStep == 0) {
                                if (_formKeyCustomer.currentState!.validate()) {
                                  pageController.animateToPage(1,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                  _animationControllerProgressBar
                                      .animateTo(3.5);
                                }
                              } else if (currentStep == 1) {
                                pageController.animateToPage(2,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                                _animationControllerProgressBar.animateTo(5.5);
                              } else if (currentStep == 2) {
                                if (context
                                    .read<OrderProvider>()
                                    .cartList
                                    .isNotEmpty) {
                                  pageController.animateToPage(3,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                  _animationControllerProgressBar
                                      .animateTo(7.5);
                                } else {
                                  fluent.displayInfoBar(
                                      alignment: fluent.Alignment.topRight,
                                      context, builder: (context, close) {
                                    return fluent.InfoBar(
                                      title: const Text('Error!'),
                                      content:
                                          const Text('Please add item first'),
                                      severity: fluent.InfoBarSeverity.error,
                                      action: IconButton(
                                        icon: const Icon(
                                            fluent.FluentIcons.clear),
                                        onPressed: close,
                                      ),
                                    );
                                  });
                                }
                              } else if (currentStep == 3) {
                                if (_fromKeyPayment.currentState!.validate()) {
                                  pageController.animateToPage(4,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                  _animationControllerProgressBar
                                      .animateTo(9.5);
                                }
                              } else if (currentStep == 4) {
                                OrderModel? orderModelAsync = await context
                                    .read<OrderProvider>()
                                    .getOrderDetail(
                                        widget.orderId, widget.orderDate);
                                if (orderModel != null) {
                                  print('oldCartList.length');
                                  print(orderModelAsync!.cart.length);
                                  print(
                                      'context.read<OrderProvider>().cartList.length');
                                  print(context
                                      .read<OrderProvider>()
                                      .cartList
                                      .length);

                                  // new data
                                  List<CartModel> allCartList =
                                      context.read<OrderProvider>().cartList;

                                  List<CartModel> oldCartList =
                                      orderModelAsync.cart;

                                  List<CartModel> addedCartList = allCartList
                                      .where((element) => !oldCartList
                                          .map((e) => e.product.id)
                                          .contains(element.product.id))
                                      .toList();

                                  List<CartModel> removedCartList = oldCartList
                                      .where((element) => !allCartList
                                          .map((e) => e.product.id)
                                          .contains(element.product.id))
                                      .toList();

                                  List<CartModel> updatedCartList = allCartList
                                      .where((element) => oldCartList
                                          .map((e) => e.product.id)
                                          .contains(element.product.id))
                                      .toList();

                                  // remove where old qty = new qty
                                  updatedCartList.removeWhere((element) =>
                                      oldCartList
                                          .firstWhere((e) =>
                                              e.product.id ==
                                              element.product.id)
                                          .quantity ==
                                      element.quantity);
                                  print('addedCartList');
                                  print(addedCartList);

                                  print('-' * 50);
                                  print(
                                      'removedCartList : ${removedCartList.length}');
                                  print(
                                      'addedCartList : ${addedCartList.length}');
                                  print(
                                      'updatedCartList : ${updatedCartList.length}');
                                  print('-' * 50);
                                  ActionMap actionMap = ActionMap(
                                    addedCart: addedCartList,
                                    removedCart: removedCartList,
                                    updatedCart: updatedCartList,
                                  );

                                  String newUserId = context
                                      .read<AuthProvider>()
                                      .getUser()!
                                      .id;

                                  int newCustomerId = selectedCustomerId;
                                  DateTime newDate = selectedDate;
                                  double newPaidAmount = _paymentAmount;
                                  String newNote = _noteController.text;

                                  UpdateOrderParam updateOrderParam =
                                      UpdateOrderParam(
                                    orderId: orderModelAsync.id!,
                                    orderDate: orderModelAsync.date,
                                    userId:
                                        orderModelAsync.user.uid != newUserId
                                            ? newUserId
                                            : null,
                                    customerId: orderModelAsync.customer.id !=
                                            newCustomerId
                                        ? newCustomerId
                                        : null,
                                    date: orderModelAsync.date
                                                .copyWith(hour: 0, minute: 0) !=
                                            newDate.copyWith(hour: 0, minute: 0)
                                        ? newDate.copyWith(hour: 0, minute: 0)
                                        : null,
                                    time: orderModelAsync.time.hour !=
                                                newDate.hour ||
                                            orderModelAsync.time.minute !=
                                                newDate.minute
                                        ? TimeOfDay(
                                            hour: newDate.hour,
                                            minute: newDate.minute)
                                        : null,
                                    actionMap: actionMap,
                                    paidAmount: orderModelAsync.paidAmount !=
                                            newPaidAmount
                                        ? newPaidAmount
                                        : null,
                                    note: orderModelAsync.orderNote != newNote
                                        ? newNote
                                        : null,
                                  );

                                  context
                                      .read<OrderProvider>()
                                      .updateOrder(updateOrderParam)
                                      .then((value) {
                                    if (value != null) {
                                      _animationControllerProgressBar
                                          .animateTo(11);
                                      pageController
                                          .animateToPage(5,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeIn)
                                          .whenComplete(() {
                                        _animationController.forward();
                                        setState(() {
                                          widget.orderDate = value.date;
                                          widget.orderId = value.orderId!;
                                        });
                                      });
                                    } else {
                                      fluent.displayInfoBar(
                                          alignment: fluent.Alignment.topRight,
                                          context, builder: (context, close) {
                                        return fluent.InfoBar(
                                          title: const Text('Error!'),
                                          content: const Text(
                                              'Error updating order'),
                                          severity:
                                              fluent.InfoBarSeverity.error,
                                          action: IconButton(
                                            icon: const Icon(
                                                fluent.FluentIcons.clear),
                                            onPressed: close,
                                          ),
                                        );
                                      });
                                    }
                                  });
                                }
                              }
                            }),
                      ],
                    ),
                  ),
            content: fluent.Column(
              children: [
                CustomStepperWidget(
                  currentStep: currentStep,
                  controller: _animationControllerProgressBar,
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
                              },
                              placeholder: 'Select Customer',
                              items: List.generate(
                                lstCustomers.length,
                                (index) => fluent.AutoSuggestBoxItem<int>(
                                    label:
                                        '${lstCustomers[index].fName} ${lstCustomers[index].lName}',
                                    value: lstCustomers[index].id),
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
                                selectedDate = selectedDate.copyWith(
                                    year: time.year,
                                    month: time.month,
                                    day: time.day);
                              });
                            },
                          ),
                          const fluent.SizedBox(
                            height: 10,
                          ),
                          fluent.TimePicker(
                            selected: selectedDate,
                            onChanged: (DateTime time) {
                              setState(() {
                                selectedDate = selectedDate.copyWith(
                                    hour: time.hour, minute: time.minute);
                              });
                            },
                            hourFormat: fluent.HourFormat.HH,
                          ),
                        ],
                      ),
                    ),
                    // page for fill order
                    fluent.Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: fluent.Container(
                        child: context
                                .watch<OrderProvider>()
                                .cartList
                                .isNotEmpty
                            ? fluent.Column(children: [
                                fluent.Expanded(
                                  child: fluent.ListView.builder(
                                      itemCount: context
                                          .watch<OrderProvider>()
                                          .cartList
                                          .length,
                                      itemBuilder: (context, index) {
                                        return fluent.ListTile(
                                          shape: fluent.RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          leading: fluent.Image(
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const SizedBox();
                                            },
                                            image: NetworkImage(context
                                                .watch<OrderProvider>()
                                                .cartList[index]
                                                .product
                                                .imageUrl),
                                            width: 50,
                                            height: 50,
                                          ),
                                          title: fluent.Text(context
                                              .watch<OrderProvider>()
                                              .cartList[index]
                                              .product
                                              .name),
                                          subtitle: fluent.Text(
                                              '${context.watch<OrderProvider>().cartList[index].product.price}'),
                                          trailing: fluent.Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              fluent.IconButton(
                                                onPressed: () {
                                                  int currentQty = context
                                                      .read<OrderProvider>()
                                                      .cartList[index]
                                                      .quantity;
                                                  if (currentQty > 1) {
                                                    context
                                                        .read<OrderProvider>()
                                                        .updateQuantityCartList(
                                                            index,
                                                            currentQty - 1);
                                                  } else {
                                                    context
                                                        .read<OrderProvider>()
                                                        .removeCartList(context
                                                            .read<
                                                                OrderProvider>()
                                                            .cartList[index]);
                                                  }
                                                },
                                                icon: const fluent.Icon(
                                                    fluent.FluentIcons.remove),
                                              ),
                                              fluent.Text(
                                                  context
                                                      .watch<OrderProvider>()
                                                      .cartList[index]
                                                      .quantity
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  )),
                                              fluent.IconButton(
                                                onPressed: () {
                                                  int currentQty = context
                                                      .read<OrderProvider>()
                                                      .cartList[index]
                                                      .quantity;
                                                  context
                                                      .read<OrderProvider>()
                                                      .updateQuantityCartList(
                                                          index,
                                                          currentQty + 1);
                                                },
                                                icon: const fluent.Icon(
                                                    fluent.FluentIcons.add),
                                              ),
                                            ],
                                          ),
                                          onPressed: () async {
                                            // global key for form builder
                                            final formKeyQty =
                                                GlobalKey<FormState>();
                                            int qty = context
                                                .read<OrderProvider>()
                                                .cartList[index]
                                                .quantity;

                                            await showDialog<bool>(
                                              context: context,
                                              builder: (context) =>
                                                  fluent.ContentDialog(
                                                constraints: BoxConstraints(
                                                    maxWidth: 400,
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8),
                                                title: fluent.Container(
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                      'Edit Quantity'),
                                                ),
                                                content: fluent.Column(
                                                  children: [
                                                    fluent.Form(
                                                      key: formKeyQty,
                                                      child: fluent
                                                          .NumberFormBox<int>(
                                                        onChanged: (value) {
                                                          setState(() {
                                                            qty = value!;
                                                          });
                                                        },
                                                        value: qty,
                                                        placeholder: 'Quantity',
                                                        min: 0,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(),
                                                          FormBuilderValidators
                                                              .integer(),
                                                          FormBuilderValidators.min(
                                                              1,
                                                              errorText:
                                                                  'Quantity must be greater than 0'),
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
                                                    child:
                                                        const Text('Confirm'),
                                                    onPressed: () {
                                                      if (formKeyQty
                                                          .currentState!
                                                          .validate()) {
                                                        context
                                                            .read<
                                                                OrderProvider>()
                                                            .updateQuantityCartList(
                                                                index, qty);
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const fluent.Text('Total Amount'),
                                      fluent.Text(context
                                          .watch<OrderProvider>()
                                          .totalAmount
                                          .toString()),
                                    ],
                                  ),
                                ),
                              ])
                            : const fluent.Center(
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
                      padding: const EdgeInsets.all(10),
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.min(0,
                                      errorText:
                                          'Payment amount must be greater than 0'),
                                ]),
                              ),
                            ),
                            const fluent.SizedBox(
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
                                  fluent.RichText(
                                    text: fluent.TextSpan(
                                      text: _noteController.text.length
                                          .toString(),
                                      style: TextStyle(
                                        color: _noteController.text.length > 200
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: '/200',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            fluent.Card(
                              child: fluent.Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const fluent.Text('Total Amount'),
                                  fluent.Text(context
                                      .watch<OrderProvider>()
                                      .totalAmount
                                      .toString()),
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
                                child: const fluent.Icon(
                                    fluent.FluentIcons.date_time),
                              ),
                              const fluent.SizedBox(
                                width: 10,
                              ),
                              fluent.Expanded(
                                child: fluent.Text(
                                    DateHelper.getFormattedDateTime(
                                        selectedDate)),
                              ),
                            ],
                          ),
                          const fluent.SizedBox(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue,
                                        ),
                                        child: const fluent.Icon(
                                            fluent.FluentIcons.contact),
                                      ),
                                      const fluent.SizedBox(
                                        width: 10,
                                      ),
                                      fluent.Expanded(
                                        child: fluent.Text(
                                            '${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).fName} ${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).lName}'),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue,
                                        ),
                                        child: const fluent.Icon(
                                            fluent.FluentIcons.phone),
                                      ),
                                      const fluent.SizedBox(
                                        width: 10,
                                      ),
                                      fluent.Text(
                                          '${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).countryCode}${lstCustomers.firstWhere((element) => element.id == selectedCustomerId).phoneNumber}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          const fluent.SizedBox(
                            height: 10,
                          ),
                          fluent.Expanded(
                            child: fluent.ListView.builder(
                                itemCount: context
                                    .watch<OrderProvider>()
                                    .cartList
                                    .length,
                                itemBuilder: (context, index) {
                                  return fluent.ListTile(
                                    shape: fluent.RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    leading: fluent.Image(
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return SizedBox();
                                      },
                                      image: NetworkImage(context
                                          .watch<OrderProvider>()
                                          .cartList[index]
                                          .product
                                          .imageUrl),
                                      width: 50,
                                      height: 50,
                                    ),
                                    title: fluent.Text(context
                                        .watch<OrderProvider>()
                                        .cartList[index]
                                        .product
                                        .name),
                                    subtitle: fluent.Text(
                                        '${context.watch<OrderProvider>().cartList[index].product.price}'),
                                    trailing: fluent.Text(context
                                        .watch<OrderProvider>()
                                        .cartList[index]
                                        .quantity
                                        .toString()),
                                  );
                                }),
                          ),
                          fluent.Card(
                            child: fluent.Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const fluent.Text('Total Amount'),
                                fluent.Text(context
                                    .watch<OrderProvider>()
                                    .totalAmount
                                    .toString()),
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
                            child: const fluent.Icon(
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
                          const Text(
                            'Order has been placed successfully',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            width: 300,
                            height: 50,
                            child: fluent.FilledButton(
                              onPressed: () {
                                String date = DateHelper.getFormattedDate(
                                    widget.orderDate);
                                context.go('/orders/$date/${widget.orderId}');
                              },
                              child: const fluent.Text('Go to Orders'),
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
