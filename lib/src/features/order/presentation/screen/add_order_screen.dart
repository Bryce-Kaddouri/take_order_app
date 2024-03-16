import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/main.dart';
import 'package:take_order_app/src/features/customer/presentation/provider/customer_provider.dart';
import 'package:take_order_app/src/features/product/presentation/provider/product_provider.dart';

import '../../../auth/presentation/screen/signin_screen.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../product/data/model/product_model.dart';
import '../widget/add_order_bottom_bar.dart';
import '../widget/add_order_fill_order_widget.dart';
import '../widget/add_order_payment_detail_widget.dart';
import '../widget/add_order_review_order_widget.dart';
import '../widget/add_order_select_customer_widget.dart';
import '../widget/add_order_select_date_time_widget.dart';
import '../widget/add_order_success_widget.dart';
import '../widget/custom_stepper_widget.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen>
    with TickerProviderStateMixin {
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
        return /*'Customer Details'*/ TranslationHelper(context: context)
            .getTranslation('customerDetails');
      case 1:
        return /*'Date & Time'*/ TranslationHelper(context: context)
            .getTranslation('dateAndTime');
      case 2:
        return /*'Fill Order'*/ TranslationHelper(context: context)
            .getTranslation('fillOrder');
      case 3:
        return /*'Payment Detail'*/ TranslationHelper(context: context)
            .getTranslation('paymentDetails');
      case 4:
        return /* 'Review Order'*/ TranslationHelper(context: context)
            .getTranslation('reviewOrder');
      case 5:
        return TranslationHelper(context: context).getTranslation('success');
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
      backgroundColor:
          FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: material.AppBar(
        leading: currentStep == 0
            ? material.BackButton(
                onPressed: () async {
                  bool? isConfirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => ContentDialog(
                      constraints: BoxConstraints(
                          maxWidth: 350,
                          maxHeight: MediaQuery.of(context).size.height * 0.8),
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
                            Text(TranslationHelper(context: context)
                                .getTranslation('confirmCancel')),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Button(
                          child: Text(TranslationHelper(context: context)
                              .getTranslation('no')),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                        FilledButton(
                          child: Text(TranslationHelper(context: context)
                              .getTranslation('yes')),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ),
                  );

                  if (isConfirmed != null && isConfirmed) {
                    context.go('/');
                  }
                },
              )
            : null,
        centerTitle: true,
        shadowColor: FluentTheme.of(context).shadowColor,
        surfaceTintColor:
            FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor:
            FluentTheme.of(context).navigationPaneTheme.backgroundColor,
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
              animationController: _animationController),
      body: DismissKeyboard(
        child: Column(
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
                      selectedDate = selectedDate.copyWith(
                          year: time.year, month: time.month, day: time.day);
                    });
                  },
                  onSelectedTime: (DateTime time) {
                    setState(() {
                      selectedDate = selectedDate.copyWith(
                          hour: time.hour, minute: time.minute);
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
                ReviewOrderPage(
                    selectedDate: selectedDate,
                    selectedCustomerId: selectedCustomerId,
                    lstCustomers: lstCustomers),

                // success page
                SuccessPage(animation: _animation),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
