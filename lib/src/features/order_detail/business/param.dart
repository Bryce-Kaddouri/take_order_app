import 'package:flutter/material.dart';

import '../../cart/data/model/cart_model.dart';

class UpdateOrderParam {
  final int orderId;
  final DateTime orderDate;
  final String? userId;
  final int? customerId;
  final DateTime? date;
  final TimeOfDay? time;
  final ActionMap? actionMap;
  final double? paidAmount;
  final String? note;
  final int? status;

  UpdateOrderParam({
    required this.orderId,
    required this.orderDate,
    this.userId,
    this.customerId,
    this.date,
    this.time,
    this.actionMap,
    this.paidAmount,
    this.note,
    this.status,
  });
}

class ActionMap {
  final List<CartModel> addedCart;
  final List<CartModel> removedCart;
  final List<CartModel> updatedCart;

  ActionMap({
    required this.addedCart,
    required this.removedCart,
    required this.updatedCart,
  });
}
