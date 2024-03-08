import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:take_order_app/src/features/order/data/model/place_order_model.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../cart/data/model/cart_model.dart';
import '../model/order_model.dart';

class OrderDataSource {
  final _client = Supabase.instance.client;

  Future<Either<DatabaseFailure, bool>> placeOrder(PlaceOrderModel order) async {
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
      };
      List<Map<String, dynamic>> response = await _client.from('orders').insert(orderInfo).select();
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
          List<Map<String, dynamic>> cartResponse = await _client.from('cart').insert(cartInfo).select();
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

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(DateTime date) async {
    try {
      var response = await _client.from('all_orders_view').select().eq('order_date', date.toIso8601String()).order('order_time', ascending: true);
      print('response from getOrders');
      print(response);

      if (response.isNotEmpty) {
        List<OrderModel> orderList = response.map((e) => OrderModel.fromJson(e)).toList();
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

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(int customerId) async {
    print('getOrdersBySupplierId');
    try {
      List<Map<String, dynamic>> response = await _client.from('all_orders_view').select().eq('customer ->> customer_id', customerId).order('order_time', ascending: true);
/*
          response = response.where((element) => element['customer']['customer_id'] == supplierId).toList();
*/
      List<OrderModel> orderList = response.map((e) => OrderModel.fromJson(e)).toList();

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

  Future<Either<DatabaseFailure, OrderModel>> getOrderById(int orderId, DateTime date) async {
    try {
      var response = await _client.from('all_orders_view').select().eq('order_id', orderId).eq('order_date', date.toIso8601String());
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
}
