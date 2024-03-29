import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/features/order/business/param/get_order_by_id_param.dart';
import 'package:take_order_app/src/features/order/business/repository/order_repository.dart';
import 'package:take_order_app/src/features/order_detail/business/param.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';

class OrderUpdateOrderUseCase
    implements UseCase<GetOrderByIdParam, UpdateOrderParam> {
  final OrderRepository orderRepository;

  const OrderUpdateOrderUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, GetOrderByIdParam>> call(
      UpdateOrderParam updateOrderParam) {
    return orderRepository.updateOrder(updateOrderParam);
  }
}
