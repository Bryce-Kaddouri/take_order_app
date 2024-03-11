import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/features/order/business/param/get_order_by_id_param.dart';
import 'package:take_order_app/src/features/order/business/repository/order_repository.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';

class OrderUpdateToCollectedUseCase
    implements UseCase<bool, GetOrderByIdParam> {
  final OrderRepository orderRepository;

  const OrderUpdateToCollectedUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, bool>> call(GetOrderByIdParam param) {
    return orderRepository.updateToCollectedOrder(param);
  }
}
