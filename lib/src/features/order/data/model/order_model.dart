import 'package:flutter/material.dart';

import '../../../auth/data/model/user_model.dart';
import '../../../cart/data/model/cart_model.dart';
import '../../../customer/data/model/customer_model.dart';
import '../../../status/data/model/status_model.dart';

class OrderModel {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final TimeOfDay time;

  final CustomerModel customer;
  final StatusModel status;
  final UserModel user;
  final List<CartModel> cart;

  OrderModel({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.time,
    required this.customer,
    required this.status,
    required this.user,
    required this.cart,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    /*List<dynamic> cart =
        json['cart']['cart_items'] as List<Map<String, dynamic>>;*/

    List<Map<String, dynamic>> jsonCart =
        json['cart']['cart_items'].cast<Map<String, dynamic>>();

    return OrderModel(
      id: json['order_id'],
      createdAt: DateTime.parse(json['order_created_at']),
      updatedAt: DateTime.parse(json['order_updated_at']),
      date: DateTime.parse(json['order_date']),
      time: TimeOfDay(
        hour: int.parse(json['order_time'].split(':')[0]),
        minute: int.parse(json['order_time'].split(':')[1]),
      ),
      customer: CustomerModel.fromJson(json['customer']),
      status: StatusModel.fromJson(json['status']),
      user: UserModel.fromJson(json),
      cart: jsonCart.map((e) => CartModel.fromJson(e)).toList(),
    );
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, date: $date, time: $time, customer: $customer, status: $status, user: $user, cart: $cart)';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'customer': customer.toJson(),
        'status': status.toJson(),
        'user': user.toJson(),
        'cart': cart.map((e) => e.toJson()).toList(),
      };
}
