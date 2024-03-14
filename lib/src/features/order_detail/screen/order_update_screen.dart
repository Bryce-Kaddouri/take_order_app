import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/order_detail/business/param.dart';

import '../../cart/data/model/cart_model.dart';
import '../../customer/data/model/customer_model.dart';
import '../../customer/presentation/provider/customer_provider.dart';
import '../../order/data/model/order_model.dart';
import '../../order/presentation/provider/order_provider.dart';
import '../../order/presentation/widget/add_order_bottom_bar.dart';
import '../../order/presentation/widget/add_order_fill_order_widget.dart';
import '../../order/presentation/widget/add_order_payment_detail_widget.dart';
import '../../order/presentation/widget/add_order_review_order_widget.dart';
import '../../order/presentation/widget/add_order_select_customer_widget.dart';
import '../../order/presentation/widget/add_order_select_date_time_widget.dart';
import '../../order/presentation/widget/add_order_success_widget.dart';
import '../../order/presentation/widget/custom_stepper_widget.dart';
import '../../product/data/model/product_model.dart';
import '../../product/presentation/provider/product_provider.dart';

class OrderUpdateScreen extends StatefulWidget {
  final int orderId;
  final DateTime orderDate;

  const OrderUpdateScreen({super.key, required this.orderId, required this.orderDate});

  @override
  State<OrderUpdateScreen> createState() => _OrderUpdateScreenState();
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> with TickerProviderStateMixin {
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
  final _formKeyPayment = GlobalKey<FormState>();

  List<CustomerModel> lstCustomers = [];
  List<ProductModel> lstProducts = [];
  int selectedCustomerId = -1;
  DateTime selectedDate = DateTime.now().add(Duration(days: 1)).copyWith(
        hour: 9,
        minute: 0,
        second: 0,
      );
  double numberBoxValue = 0.0;
  PageController pageController = PageController();
  // controller for customer
  final TextEditingController customerController = TextEditingController();
  int selectedCustomerIndex = -1;
  // controller for payment amount
  double _paymentAmount = 0.0;
  // controller for note
  final TextEditingController _noteController = TextEditingController();

  List<CartModel> oldCartList = [];

  // controller for payment amount
  // controller for note
  OrderModel? orderModel;
  int? newOrderId;
  DateTime? newOrderDate;

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
        context.read<OrderProvider>().getOrderDetail(widget.orderId, widget.orderDate).then((value) {
          setState(() {
            orderModel = value;
            oldCartList = value!.cart;
            print(value!.cart);
            // init customerController
            customerController.text = '${orderModel!.customer.fName} ${orderModel!.customer.lName}';
            selectedCustomerId = orderModel!.customer.id!;
            // init selected date
            selectedDate = orderModel!.date.copyWith(hour: orderModel!.time.hour, minute: orderModel!.time.minute);
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
          : AddOrderBottomBar(
              currentStep: currentStep,
              pageController: pageController,
              animationControllerProgressBar: _animationControllerProgressBar,
              formKeyCustomer: _formKeyCustomer,
              lstProducts: lstProducts,
              formKeyPayment: _formKeyPayment,
              paymentAmount: _paymentAmount,
              noteController: _noteController,
              selectedDate: selectedDate,
              selectedCustomerId: selectedCustomerId,
              lstCustomers: lstCustomers,
              animationController: _animationController,
              isUpdate: true,
              orderDate: widget.orderDate,
              orderId: widget.orderId,
              orderModel: orderModel,
              onUpdateDate: (UpdateOrderParam param) {
                context.read<OrderProvider>().updateOrder(param).then((value) {
                  if (value != null) {
                    _animationControllerProgressBar.animateTo(11);
                    pageController.animateToPage(5, duration: Duration(milliseconds: 300), curve: Curves.easeIn).whenComplete(() {
                      _animationController.forward();
                    });
                    print('Order updated successfully');
                    print(value);
                    setState(() {
                      newOrderId = value.orderId;
                      newOrderDate = value.date;
                    });
                  } else {
                    displayInfoBar(alignment: Alignment.topRight, context, builder: (context, close) {
                      return InfoBar(
                        title: const Text('Error!'),
                        content: const Text('Error updating order'),
                        severity: InfoBarSeverity.error,
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                      );
                    });
                  }
                });
              },
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
              SelectCustomerPage(
                customerController: customerController,
                formKeyCustomer: _formKeyCustomer,
                lstCustomers: lstCustomers,
                selectedCustomerId: selectedCustomerId,
                onSelected: (int val) {
                  setState(() {
                    selectedCustomerId = val;
                  });
                },
              ),
              // page for date and time
              SelectDateTimePage(
                selectedDate: selectedDate,
                onSelectedDate: (DateTime time) {
                  setState(() {
                    selectedDate = selectedDate.copyWith(year: time.year, month: time.month, day: time.day);
                  });
                },
                onSelectedTime: (DateTime time) {
                  setState(() {
                    selectedDate = selectedDate.copyWith(hour: time.hour, minute: time.minute);
                  });
                },
              ),

              // page for fill order
              FillOrderPage(),

              // page for payment
              PaymentDetailPage(
                  fromKeyPayment: _formKeyPayment,
                  paymentAmount: _paymentAmount,
                  onChangedPaidAmount: (double val) {
                    setState(() {
                      _paymentAmount = val;
                    });
                  },
                  noteController: _noteController),
              // page for review
              ReviewOrderPage(selectedDate: selectedDate, selectedCustomerId: selectedCustomerId, lstCustomers: lstCustomers),

              // success page
              SuccessPage(animation: _animation, isUpdate: true, orderId: newOrderId, orderDate: newOrderDate),
            ]),
          ),
        ],
      ),
    );
  }
}
