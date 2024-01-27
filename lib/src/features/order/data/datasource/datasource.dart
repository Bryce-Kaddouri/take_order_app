import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:take_order_app/src/features/customer/data/datasource/customer_datasource.dart';

import '../../../cart/data/model/cart_model.dart';
import '../../../product/data/model/product_model.dart';
import '../model/order_model.dart';

class OrderDataSource {
  final _client = Supabase.instance.client;

  /*Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrder(String id);*/
  Future<OrderModel?> createOrder(OrderModel order) async {
    print('create order');
    try {
      Map<String, dynamic> orderInfo = {
        'created_at': order.createdAt.toIso8601String(),
        'updated_at': order.updatedAt.toIso8601String(),
        /*'customer_id': order.customer.id,
        'status_id': order.status.id,
        'user_id': order.user.uid,*/
        'date': order.date.toIso8601String(),
        'time': '${order.time.hour}:${order.time.minute}',
      };
      List<Map<String, dynamic>> response =
          await _client.from('orders').insert(orderInfo).select();
      print(response);
      if (response.isNotEmpty) {
        /*List<CartModel> cartDatas = order.cart;
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
        print('response is not empty');*/
        /*CategoryModel categoryModel = CategoryModel.fromJson(response[0]);
        print(categoryModel.toJson());
        return Right(categoryModel);*/
      } else {
        print('response is empty');
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
          .from('all_orders_view')
          .select()
          .order('order_time', ascending: true);
      print('response from getOrders');
      print(response);

      if (response.isNotEmpty) {
        List<OrderModel> orderList =
            response.map((e) => OrderModel.fromJson(e)).toList();
        print('order list');
        print(orderList);
        return orderList;
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

  Future<List<OrderModel>> getOrdersByCustomerId(int customerId) async {
    try {


      // get orders by customer id (customer field is jsonb type so we need to use ->> operator)
      // https://supabase.io/docs/guides/database#selecting-data

     /* select
          *
          from
      all_orders_view
      where
      (customer ->> 'customer_id')::int = 1;*/

      var response = await _client
          .from('users')

          /*.select('* ->> customer_id as customer_id')*/
      .select(

      );
/*
          .eq('test_json->customer_id', customerId);
*/


     /* .contains('customer', {'customer_id': customerId})*/

/*
          .order('order_time', ascending: true);
*/
print('response from getOrdersByCustomerId');
print(response);


      if (response.isNotEmpty) {
      /*  List<OrderModel> orderList =
        response.map((e) => OrderModel.fromJson(e)).toList();
        print(orderList);*/
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

  Future<List<Object>> getOrdersBySupplierId(int customerId) async{
    print('getOrdersBySupplierId');
    try {
      List<Map<String, dynamic>> response = await _client.
      from('all_orders_view').select()
          .eq('customer ->> customer_id', customerId).order('order_time', ascending: true);
/*
          response = response.where((element) => element['customer']['customer_id'] == supplierId).toList();
*/
      List<OrderModel> orderList = response.map((e) => OrderModel.fromJson(e)).toList();

      return orderList;
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
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }


}
