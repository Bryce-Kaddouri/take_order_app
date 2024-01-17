import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/order_model.dart';

class OrderDataSource {
  final _client = Supabase.instance.client;

  /*Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrder(String id);*/
  Future<OrderModel?> createOrder(OrderModel order) async {
    try {
      Map<String, dynamic> orderInfo = {
        'created_at': order.createdAt.toIso8601String(),
        'updated_at': order.updatedAt.toIso8601String(),
        'customer_id': order.customer.id,
        'status_id': order.statusId,
        'user_id': order.userId,
        'date': order.date.toIso8601String(),
        'time': '${order.time.hour}:${order.time.minute}',
      };
      List<Map<String, dynamic>> response =
          await _client.from('orders').insert(orderInfo).select();
      print(response);
      if (response.isNotEmpty) {
        List<CartModel> cartDatas = order.cart;
        for (int i = 0; i < cartDatas.length; i++) {
          Map<String, dynamic> cartInfo = {
            'order_id': response[0]['id'],
            'order_date': response[0]['date'],
            'product_id': cartDatas[i].productId,
            'quantity': cartDatas[i].quantity,
            'is_done': cartDatas[i].isDone,
          };
          List<Map<String, dynamic>> cartResponse =
              await _client.from('cart').insert(cartInfo).select();
          print(cartResponse);
        }
        print('response is not empty');
        /*CategoryModel categoryModel = CategoryModel.fromJson(response[0]);
        print(categoryModel.toJson());
        return Right(categoryModel);*/
      } else {
        /* return Left(DatabaseFailure(errorMessage: 'Error adding category'));*/
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      /*return Left(DatabaseFailure(errorMessage: 'Error adding category'));*/
    } catch (e) {
      print(e);
      /*return Left(DatabaseFailure(errorMessage: 'Error adding category'));*/
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      // orders inner join customers on orders.customer_id = customers.id
      // example :
      //If you want to filter a table based on a child table's values you can use the !inner() function. For example, if you wanted
      //to select all rows in a message table which belong to a user with the username "Jane":

      // final data = await supabase
      //     .from('messages')
      //     .select('*, users!inner(*)')
      //     .eq('users.username', 'Jane');

      var response = await _client
          .from('orders')
          .select('*, customers!inner(*)')
          .eq('customer_id', 1);
      print(response);
      if (response.isNotEmpty) {
        print(response);
        /* List<OrderModel> orderList =
            response.map((e) => OrderModel.fromJson(e)).toList();*/
        return [];
      } else {
        return [];
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
