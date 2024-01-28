import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/features/order/business/repository/order_repository.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';
import '../../data/model/order_model.dart';

class OrderGetOrdersByCustomerIdUseCase
    implements UseCase<List<OrderModel>, int> {
  final OrderRepository orderRepository;

  const OrderGetOrdersByCustomerIdUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, List<OrderModel>>> call(int customerId) {
    return orderRepository.getOrdersByCustomerId(customerId);
  }
}
