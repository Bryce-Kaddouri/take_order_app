import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/features/order/business/repository/order_repository.dart';
import 'package:take_order_app/src/features/order/data/model/place_order_model.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';

class OrderPlaceOrderUseCase implements UseCase<bool, PlaceOrderModel> {
  final OrderRepository orderRepository;

  const OrderPlaceOrderUseCase({
    required this.orderRepository,
  });

  @override
  Future<Either<DatabaseFailure, bool>> call(PlaceOrderModel placeOrderModel) {
    return orderRepository.placeOrder(placeOrderModel);
  }
}
