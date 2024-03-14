import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';

import '../../../cart/data/model/cart_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../product/data/model/product_model.dart';
import '../../data/model/place_order_model.dart';
import '../provider/order_provider.dart';

class AddOrderBottomBar extends StatefulWidget {
  final int currentStep;
  final PageController pageController;
  final AnimationController animationControllerProgressBar;
  final AnimationController animationController;
  final GlobalKey<FormState> formKeyCustomer;
  final List<ProductModel> lstProducts;
  final GlobalKey<FormState> formKeyPayment;
  final double paymentAmount;
  final TextEditingController noteController;
  final DateTime selectedDate;
  final int selectedCustomerId;
  final List<CustomerModel> lstCustomers;

  const AddOrderBottomBar({super.key, required this.currentStep, required this.pageController, required this.animationControllerProgressBar, required this.formKeyCustomer, required this.lstProducts, required this.formKeyPayment, required this.paymentAmount, required this.noteController, required this.selectedDate, required this.selectedCustomerId, required this.lstCustomers, required this.animationController});

  @override
  State<AddOrderBottomBar> createState() => _AddOrderBottomBarState();
}

class _AddOrderBottomBarState extends State<AddOrderBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
              onPressed: widget.currentStep == 0
                  ? null
                  : () {
                      if (widget.currentStep > 0) {
                        widget.pageController.animateToPage(widget.currentStep - 1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                        if (widget.currentStep == 1) {
                          widget.animationControllerProgressBar.animateTo(1.5);
                        } else if (widget.currentStep == 2) {
                          widget.animationControllerProgressBar.animateTo(3.5);
                        } else if (widget.currentStep == 3) {
                          widget.animationControllerProgressBar.animateTo(5.5);
                        } else if (widget.currentStep == 4) {
                          widget.animationControllerProgressBar.animateTo(7.5);
                        }
                      }
                    }),
          if (widget.currentStep == 2)
            FilledButton(
              onPressed: () async {
                List<ProductModel> filteredProducts = widget.lstProducts.where((element) => !context.read<OrderProvider>().cartList.map((e) => e.product.id).contains(element.id)).toList();

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
                                  product: widget.lstProducts.firstWhere((element) => element.id == context.read<OrderProvider>().selectedProductAddId),
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
                    Text(widget.currentStep == 4 ? 'Place Order' : 'Next')
                  ],
                ),
              ),
              onPressed: () {
                if (widget.currentStep == 0) {
                  if (widget.formKeyCustomer.currentState!.validate()) {
                    /* setState(() {
                        currentStep += 1;
                      });*/
                    widget.pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    widget.animationControllerProgressBar.animateTo(3.5);
                  }
                } else if (widget.currentStep == 1) {
                  widget.pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                  widget.animationControllerProgressBar.animateTo(5.5);
                } else if (widget.currentStep == 2) {
                  if (context.read<OrderProvider>().cartList.isNotEmpty) {
                    widget.pageController.animateToPage(3, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    widget.animationControllerProgressBar.animateTo(7.5);
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
                } else if (widget.currentStep == 3) {
                  if (widget.formKeyPayment.currentState!.validate()) {
                    widget.pageController.animateToPage(4, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    widget.animationControllerProgressBar.animateTo(9.5);
                  }
                } else if (widget.currentStep == 4) {
                  List<CartModel> cartList = context.read<OrderProvider>().cartList;
                  CustomerModel customer = widget.lstCustomers.firstWhere((element) => element.id == widget.selectedCustomerId);
                  double paymentAmount = widget.paymentAmount;
                  DateTime orderDate = widget.selectedDate;
                  String note = widget.noteController.text;

                  PlaceOrderModel placeOrderModel = PlaceOrderModel(
                    cartList: cartList,
                    customer: customer,
                    paymentAmount: paymentAmount,
                    orderDate: orderDate,
                    note: note.isEmpty ? null : note,
                    orderTime: material.TimeOfDay(hour: widget.selectedDate.hour, minute: widget.selectedDate.minute),
                  );

                  context.read<OrderProvider>().placeOrder(placeOrderModel).then((value) {
                    if (value) {
                      widget.animationControllerProgressBar.animateTo(11);
                      widget.pageController.animateToPage(5, duration: Duration(milliseconds: 300), curve: Curves.easeIn).whenComplete(() => widget.animationController.forward());
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
    );
  }
}
