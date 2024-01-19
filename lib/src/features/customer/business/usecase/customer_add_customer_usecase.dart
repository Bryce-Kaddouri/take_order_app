import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:take_order_app/src/features/customer/business/repository/customer_repository.dart';
import 'package:take_order_app/src/features/customer/data/model/customer_model.dart';

import '../../../../core/data/exception/failure.dart';
import '../../../../core/data/usecase/usecase.dart';

class CustomerAddCustomerUseCase
    implements UseCase<CustomerModel, CustomerModel> {
  final CustomerRepository customerRepository;

  const CustomerAddCustomerUseCase({
    required this.customerRepository,
  });

  @override
  Future<Either<DatabaseFailure, CustomerModel>> call(
      CustomerModel customerModel) {
    return customerRepository.addCustomer(customerModel);
  }
}
