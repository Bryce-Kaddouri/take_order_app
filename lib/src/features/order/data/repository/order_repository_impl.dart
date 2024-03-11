import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/core/data/exception/failure.dart';
import 'package:take_order_app/src/features/order/business/param/get_order_by_id_param.dart';
import 'package:take_order_app/src/features/order/data/datasource/order_datasource.dart';
import 'package:take_order_app/src/features/order/data/model/order_model.dart';
import 'package:take_order_app/src/features/order/data/model/place_order_model.dart';
import 'package:take_order_app/src/features/order_detail/business/param.dart';

import '../../business/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource orderDataSource;

  OrderRepositoryImpl({
    required this.orderDataSource,
  });

  @override
  Future<Either<DatabaseFailure, OrderModel>> getOrderById(
      GetOrderByIdParam param) async {
    return await orderDataSource.getOrderById(param.orderId, param.date);
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

  @override
  Future<Either<DatabaseFailure, GetOrderByIdParam>> updateOrder(
      UpdateOrderParam updateOrderParam) async {
    return await orderDataSource.updateOrder(updateOrderParam);
  }

  @override
  Future<Either<DatabaseFailure, bool>> updateToCollectedOrder(
      GetOrderByIdParam param) async {
    return await orderDataSource.updateToCollectedOrder(param);
  }
}
