import 'package:flutter/material.dart';

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

class CategoryModel {
  final int id;
  final String name;
  final String description;
  final String photoUrl;
  final bool isVisible;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.isVisible,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['category_id'],
        name: json['category_name'],
        description: json['category_description'],
        photoUrl: json['category_photo_url'],
        isVisible: json['category_is_visible'],
      );

  Map<String, dynamic> toJson() => {
        'category_id': id,
        'category_name': name,
        'category_description': description,
        'category_photo_url': photoUrl,
        'category_is_visible': isVisible,
      };
}

class ProductModel {
  final int id;
  final String name;

  final String photoUrl;
  final double price;
  final CategoryModel category;

  ProductModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.price,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['product_id'],
        name: json['product_name'],
        photoUrl: json['product_photo_url'],
        price: json['product_price'],
        category: CategoryModel.fromJson(json['category_info']),
      );

  Map<String, dynamic> toJson() => {
        'product_id': id,
        'product_name': name,
        'product_photo_url': photoUrl,
        'product_price': price,
        'category_info': category.toJson(),
      };
}

class CartModel {
  final int? id;
  final int quantity;
  final bool isDone;
  final ProductModel product;

  CartModel({
    this.id,
    required this.quantity,
    required this.isDone,
    required this.product,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['cart_id'],
        quantity: json['quantity'],
        isDone: json['is_done'],
        product: ProductModel.fromJson(json['product_info']),
      );

  Map<String, dynamic> toJson() => {
        'cart_id': id,
        'quantity': quantity,
        'is_done': isDone,
        'product_info': product.toJson(),
      };
}

class CustomerModel {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String fName;
  final String lName;
  final String phoneNumber;

  CustomerModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.fName,
    required this.lName,
    required this.phoneNumber,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['customer_id'],
        /* createdAt: DateTime.parse(json['customer_created_at']),
        updatedAt: DateTime.parse(json['customer_updated_at']),*/
        fName: json['customer_f_name'],
        lName: json['customer_l_name'],
        phoneNumber: json['customer_phone_number'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'f_name': fName,
        'l_name': lName,
        'phone_number': phoneNumber,
      };
}

class StatusModel {
  final int id;
  final int step;
  final String name;
  final Color color;

  StatusModel({
    required this.id,
    required this.step,
    required this.name,
    required this.color,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        id: json['status_id'],
        step: json['status_step'],
        name: json['status_name'],
        color: Color.fromRGBO(json['status_color_red'],
            json['status_color_green'], json['status_color_blue'], 1),
      );

  Map<String, dynamic> toJson() => {
        'status_id': id,
        'status_step': step,
        'status_name': name,
        'status_color_red': color.red,
        'status_color_green': color.green,
        'status_color_blue': color.blue,
      };
}

class UserModel {
  final String uid;
  final String fName;
  final String lName;

  UserModel({
    required this.uid,
    required this.fName,
    required this.lName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['user_id'],
        fName: json['user_full_name']['fName'],
        lName: json['user_full_name']['lName'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'user_full_name': {
          'fName': fName,
          'lName': lName,
        },
      };
}
