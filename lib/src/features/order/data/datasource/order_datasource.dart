import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/features/order/business/param/get_order_by_id_param.dart';
import 'package:take_order_app/src/features/order/data/model/place_order_model.dart';
import 'package:take_order_app/src/features/order_detail/business/param.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../cart/data/model/cart_model.dart';
import '../model/order_model.dart';

class OrderDataSource {
  final _client = Supabase.instance.client;

  Future<Either<DatabaseFailure, bool>> placeOrder(
      PlaceOrderModel order) async {
    print('create order');
    try {
      DateTime now = DateTime.now();
      Map<String, dynamic> orderInfo = {
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'customer_id': order.customer.id,
        'status_id': 1,
        'user_id': _client.auth.currentUser!.id,
        'date': order.orderDate.toIso8601String(),
        'time': '${order.orderTime.hour}:${order.orderTime.minute}',
        'amount_paid': order.paymentAmount,
        'note': order.note,
      };
      List<Map<String, dynamic>> response =
          await _client.from('orders').insert(orderInfo).select();
      print(response);
      if (response.isNotEmpty) {
        List<CartModel> cartDatas = order.cartList;
        for (int i = 0; i < cartDatas.length; i++) {
          Map<String, dynamic> cartInfo = {
            'id': response[0]['id'],
            'date': response[0]['date'],
            'product_id': cartDatas[i].product.id,
            'quantity': cartDatas[i].quantity,
            'is_done': cartDatas[i].isDone,
          };
          List<Map<String, dynamic>> cartResponse =
              await _client.from('cart').insert(cartInfo).select();
          print(cartResponse);
        }

        print('response is not empty');
        return const Right(true);
        /*CategoryModel categoryModel = CategoryModel.fromJson(response[0]);
        print(categoryModel.toJson());
        return Right(categoryModel);*/
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error adding order'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: error.message));
      /*return Left(DatabaseFailure(errorMessage: 'Error adding category'));*/
    } catch (e) {
      print(e);
      return Left(DatabaseFailure(errorMessage: 'Error adding category'));
      /*return Left(DatabaseFailure(errorMessage: 'Error adding category'));*/
    }
  }

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      DateTime date) async {
    try {
      var response = await _client
          .from('all_orders_view')
          .select()
          .eq('order_date', date.toIso8601String())
          .order('order_time', ascending: true);
      print('response from getOrders');
      print(response);

      if (response.isNotEmpty) {
        List<OrderModel> orderList =
            response.map((e) => OrderModel.fromJson(e)).toList();
        print('order list');
        print(orderList);
        return Right(orderList);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting orders'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: error.message));
    } catch (e) {
      print('e');

      print(e);
      return Left(DatabaseFailure(errorMessage: 'Error getting orders'));
    }
  }

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(
      int customerId) async {
    print('getOrdersBySupplierId');
    try {
      List<Map<String, dynamic>> response = await _client
          .from('all_orders_view')
          .select()
          .eq('customer ->> customer_id', customerId)
          .order('order_time', ascending: true);
/*
          response = response.where((element) => element['customer']['customer_id'] == supplierId).toList();
*/
      List<OrderModel> orderList =
          response.map((e) => OrderModel.fromJson(e)).toList();

      return Right(orderList);
      /*.from('all_orders_view')
          .select();*/
/*
          .eq('supplier_id', supplierId)
*/
/*
          .order('order_time', ascending: true);
*/
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: error.message));
    } catch (e) {
      print(e);
      return Left(DatabaseFailure(errorMessage: 'Error getting orders'));
    }
  }

  Future<Either<DatabaseFailure, OrderModel>> getOrderById(
      int orderId, DateTime date) async {
    try {
      var response = await _client
          .from('all_orders_view')
          .select()
          .eq('order_id', orderId)
          .eq('order_date', date.toIso8601String());
      print('response from getOrderById');
      print(response);

      if (response.isNotEmpty) {
        OrderModel order = OrderModel.fromJson(response[0]);
        print('order');
        print(order);
        return Right(order);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting order'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: error.message));
    } catch (e) {
      print('e');

      print(e);
      return Left(DatabaseFailure(errorMessage: 'Error getting order'));
    }
  }

  Future<Either<DatabaseFailure, GetOrderByIdParam>> updateOrder(
      UpdateOrderParam updateOrderParam) async {
    print('update order');
    int orderId = updateOrderParam.orderId;
    String orderDate = DateHelper.getFormattedDate(updateOrderParam.orderDate);
    print('orderId');
    print(orderId);
    print('orderDate');
    print(orderDate);
    print('time');
    print('${updateOrderParam.time?.hour}:${updateOrderParam.time?.minute}:00');

    Map<String, dynamic> orderInfo = {
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (updateOrderParam.time != null) {
      orderInfo['time'] =
          '${updateOrderParam.time?.hour}:${updateOrderParam.time?.minute}:00';
    }
    if (updateOrderParam.date != null) {
      orderInfo['date'] = updateOrderParam.date!.toIso8601String();
    }
    if (updateOrderParam.userId != null) {
      orderInfo['user_id'] = updateOrderParam.userId;
    }
    if (updateOrderParam.customerId != null) {
      orderInfo['customer_id'] = updateOrderParam.customerId;
    }
    if (updateOrderParam.paidAmount != null) {
      orderInfo['amount_paid'] = updateOrderParam.paidAmount;
    }
    if (updateOrderParam.status != null) {
      orderInfo['status_id'] = updateOrderParam.status;
    }
    if (updateOrderParam.note != null) {
      orderInfo['note'] = updateOrderParam.note;
    }

    List<CartModel> addedCart = updateOrderParam.actionMap?.addedCart ?? [];
    List<CartModel> removedCart = updateOrderParam.actionMap?.removedCart ?? [];
    List<CartModel> updatedCart = updateOrderParam.actionMap?.updatedCart ?? [];

    print('addedCart');
    print(addedCart);
    print('removedCart');
    print(removedCart);
    print('updatedCart');
    print(updatedCart);

    print('orderInfo');
    print(orderInfo);
    try {
      var response = await _client
          .from('orders')
          .update(orderInfo)
          .eq('id', orderId)
          .eq('date', updateOrderParam.orderDate.toIso8601String())
          .select()
          .single();

      print('response from updateOrder');
      print(response);

      DateTime date = DateTime.parse(response['date']);
      int id = response['id'];
      print('newDate : $date');
      GetOrderByIdParam getOrderByIdParam =
          GetOrderByIdParam(orderId: id, date: date);

      if (addedCart.isNotEmpty) {
        for (int i = 0; i < addedCart.length; i++) {
          Map<String, dynamic> cartInfo = {
            'id': id,
            'date': date.toIso8601String(),
            'product_id': addedCart[i].product.id,
            'quantity': addedCart[i].quantity,
            'is_done': addedCart[i].isDone,
          };
          List<Map<String, dynamic>> cartResponse =
              await _client.from('cart').insert(cartInfo).select();
          print(cartResponse);
        }
      }
      if (removedCart.isNotEmpty) {
        for (int i = 0; i < removedCart.length; i++) {
          List<Map<String, dynamic>> cartResponse = await _client
              .from('cart')
              .delete()
              .eq('id', id)
              .eq('date', date.toIso8601String())
              .eq('product_id', removedCart[i].product.id)
              .select();
          print(cartResponse);
        }
      }
      if (updatedCart.isNotEmpty) {
        for (int i = 0; i < updatedCart.length; i++) {
          List<Map<String, dynamic>> cartResponse = await _client
              .from('cart')
              .update({
                'quantity': updatedCart[i].quantity,
              })
              .eq('id', id)
              .eq('date', date.toIso8601String())
              .eq('product_id', updatedCart[i].product.id)
              .select();
          print(cartResponse);
        }
      }
      return Right(getOrderByIdParam);
      /*CategoryModel categoryModel = CategoryModel.fromJson(response[0]);
        print(categoryModel.toJson());
        return Right(categoryModel);*/
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: error.message));
      /*return Left(DatabaseFailure(errorMessage: 'Error adding category'));*/
    } catch (e) {
      print('error');
      print(e);
      return Left(DatabaseFailure(errorMessage: 'Error updating order'));
      /*return Left(DatabaseFailure(errorMessage: 'Error adding category'));*/
    }
  }
}
