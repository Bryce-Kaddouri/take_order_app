import 'package:flutter/material.dart';
import 'package:take_order_app/src/features/customer/data/model/customer_model.dart';

import '../../../cart/data/model/cart_model.dart';

class PlaceOrderModel {
  final List<CartModel> cartList;
  final CustomerModel customer;
  final String? note;
  final double paymentAmount;
  final DateTime orderDate;
  final TimeOfDay orderTime;

  PlaceOrderModel({
    required this.cartList,
    required this.customer,
    this.note,
    required this.paymentAmount,
    required this.orderDate,
    required this.orderTime,
  });
}
