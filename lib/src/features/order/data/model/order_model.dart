import 'dart:io';

import 'package:flutter/material.dart';

class OrderModel {
  final int? id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final TimeOfDay time;

  final CustomerModel customer;
  final int statusId;
  final String userId;
  final List<CartModel> cart;

  OrderModel({
    this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.time,
    required this.customer,
    required this.statusId,
    required this.userId,
    required this.cart,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        date: DateTime.parse(json['date']),
        time: TimeOfDay.fromDateTime(DateTime.parse(json['date'])),
        customer: CustomerModel.fromJson(json['customer']),
        statusId: json['status_id'],
        userId: json['user_id'],
        cart:
            json['cart'].map<CartModel>((e) => CartModel.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'customer': customer.toJson(),
        'status_id': statusId,
        'user_id': userId,
        'cart': cart.map((e) => e.toJson()).toList(),
      };
}

class CartModel {
  final int? orderId;
  final DateTime? orderCreatedAt;
  final int productId;
  final int quantity;
  final bool isDone;

  CartModel({
    this.orderId,
    this.orderCreatedAt,
    required this.productId,
    required this.quantity,
    required this.isDone,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        orderId: json['order_id'],
        orderCreatedAt: DateTime.parse(json['order_created_at']),
        productId: json['product_id'],
        quantity: json['quantity'],
        isDone: json['is_done'],
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'order_created_at': orderCreatedAt?.toIso8601String(),
        'product_id': productId,
        'quantity': quantity,
        'is_done': isDone,
      };
}

class CustomerModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String fName;
  final String lName;
  final String phoneNumber;

  CustomerModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.fName,
    required this.lName,
    required this.phoneNumber,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        fName: json['f_name'],
        lName: json['l_name'],
        phoneNumber: json['phone_number'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'f_name': fName,
        'l_name': lName,
        'phone_number': phoneNumber,
      };
}
