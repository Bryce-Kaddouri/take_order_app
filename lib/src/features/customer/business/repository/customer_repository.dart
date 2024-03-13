/*
import 'package:admin_dashboard/src/feature/category/business/param/category_add_param.dart';
*/
import 'package:dartz/dartz.dart';
import 'package:take_order_app/src/core/data/usecase/usecase.dart';
import 'package:take_order_app/src/features/customer/data/model/customer_model.dart';

import '../../../../core/data/exception/failure.dart';

/*
import '../../data/model/category_model.dart';
*/

abstract class CustomerRepository {
  Future<Either<DatabaseFailure, List<CustomerModel>>> getCustomers(NoParams param);
  Future<Either<DatabaseFailure, CustomerModel>> addCustomer(CustomerModel customerModel);

  Future<Either<DatabaseFailure, bool>> updateCustomer(CustomerModel customerModel);

  Future<Either<DatabaseFailure, CustomerModel>> getCustomerById(int id);
}
