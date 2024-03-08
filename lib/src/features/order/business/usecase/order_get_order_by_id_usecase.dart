import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/features/order/business/get_order_by_id_param.dart';
import 'package:take_order_app/src/features/order/business/repository/order_repository.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/order_model.dart';

class OrderGetOrdersByIdUseCase implements UseCase<OrderModel, GetOrderByIdParam> {
  final OrderRepository orderRepository;

  const OrderGetOrdersByIdUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, OrderModel>> call(GetOrderByIdParam param) {
    return orderRepository.getOrderById(param);
  }
}
