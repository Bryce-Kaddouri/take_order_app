import 'package:flutter/material.dart';
import 'package:take_order_app/src/features/order/data/datasource/datasource.dart';
import 'package:take_order_app/src/features/order/data/model/place_order_model.dart';

import '../../../cart/data/model/cart_model.dart';
import '../../../product/data/model/product_model.dart';

class OrderProvider with ChangeNotifier {
  int _orderQty = 1;
  int get orderQty => _orderQty;

  void setOrderQty(int value) {
    _orderQty = value;
    notifyListeners();
  }

  void decrementOrderQty() {
    if (_orderQty > 1) {
      _orderQty--;
      notifyListeners();
    }
  }

  void incrementOrderQty() {
    _orderQty++;
    notifyListeners();
  }

  ProductModel? _selectedProduct;
  ProductModel? get selectedProduct => _selectedProduct;

  void setSelectedProduct(ProductModel? value) {
    _selectedProduct = value;
    notifyListeners();
  }

  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;

  void setCartList(List<CartModel> value) {
    _cartList = value;
    notifyListeners();
  }

  void addCartList(CartModel value) {
    _cartList.add(value);
    notifyListeners();
  }

  void removeCartList(CartModel value) {
    _cartList.remove(value);
    notifyListeners();
  }

  void clearCartList() {
    _cartList.clear();
    notifyListeners();
  }

  void updateQuantityCartList(int index, int quantity) {
    _cartList[index].quantity = quantity;
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    for (var element in _cartList) {
      total += element.quantity * element.product.price;
    }
    return total;
  }

  Future<bool> placeOrder(PlaceOrderModel orderModel) async {
    return OrderDataSource().placeOrder(orderModel);
  }
}
