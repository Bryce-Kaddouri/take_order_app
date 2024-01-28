import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/features/order/data/model/order_model.dart';

import '../../../../core/data/exception/failure.dart';
import '../../data/model/place_order_model.dart';

abstract class OrderRepository {
  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      DateTime date);

  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(
      int customerId);

  Future<Either<DatabaseFailure, OrderModel>> getOrderById(int id);

  Future<Either<DatabaseFailure, bool>> placeOrder(
      PlaceOrderModel placeOrderModel);
}
