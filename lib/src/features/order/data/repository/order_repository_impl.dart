import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/core/data/exception/failure.dart';
import 'package:take_order_app/src/features/order/data/datasource/order_datasource.dart';
import 'package:take_order_app/src/features/order/data/model/order_model.dart';
import 'package:take_order_app/src/features/order/data/model/place_order_model.dart';

import '../../business/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource orderDataSource;

  OrderRepositoryImpl({
    required this.orderDataSource,
  });

  @override
  Future<Either<DatabaseFailure, OrderModel>> getOrderById(int id) async {
    // TODO: implement getOrderById
    throw UnimplementedError();
  }

  @override
  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByCustomerId(
      int customerId) async {
    return await orderDataSource.getOrdersByCustomerId(customerId);
  }

  @override
  Future<Either<DatabaseFailure, List<OrderModel>>> getOrdersByDate(
      DateTime date) async {
    return await orderDataSource.getOrdersByDate(date);
  }

  @override
  Future<Either<DatabaseFailure, bool>> placeOrder(
      PlaceOrderModel placeOrderModel) async {
    return await orderDataSource.placeOrder(placeOrderModel);
  }
}
