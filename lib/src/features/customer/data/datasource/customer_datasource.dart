import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:take_order_app/src/features/customer/data/model/customer_model.dart';

import '../../../../core/data/exception/failure.dart';

class CustomerDataSource {
  final _client = Supabase.instance.client;

  Future<Either<DatabaseFailure, List<CustomerModel>>> getCustomers() async {
    try {
      List<Map<String, dynamic>> response = await _client
          .from('customers')
          .select()
          .order('l_name', ascending: true);
      if (response.isNotEmpty) {
        List<CustomerModel> customerList =
            response.map((e) => CustomerModel.fromJson(e)).toList();
        return Right(customerList);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting customers'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: 'Error getting customers'));
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Error getting customers'));
    }
  }

  Future<Either<DatabaseFailure, CustomerModel>> getCustomerById(int id) async {
    try {
      List<Map<String, dynamic>> response = await _client
          .from('customers')
          .select()
          .eq('id', id)
          .limit(1)
          .order('id', ascending: true);
      if (response.isNotEmpty) {
        CustomerModel productModel = CustomerModel.fromJson(response[0]);
        return Right(productModel);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error getting customer'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: 'Error getting customer'));
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Error getting customer'));
    }
  }

  Future<Either<DatabaseFailure, CustomerModel>> addCustomer(
      CustomerModel customer) async {
    try {
      List<Map<String, dynamic>> response =
          await _client.from('customers').insert(customer.toJson()).select();
      if (response.isNotEmpty) {
        CustomerModel customerModel = CustomerModel.fromJson(response[0]);
        return Right(customerModel);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error adding customer'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: 'Error adding customer'));
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Error adding customer'));
    }
  }

  Future<Either<DatabaseFailure, CustomerModel>> updateCustomer(
      CustomerModel customer) async {
    try {
      List<Map<String, dynamic>> response = await _client
          .from('customers')
          .update(customer.toJson())
          .eq('id', customer.id)
          .select();
      if (response.isNotEmpty) {
        CustomerModel customerModel = CustomerModel.fromJson(response[0]);
        return Right(customerModel);
      } else {
        return Left(DatabaseFailure(errorMessage: 'Error updating customer'));
      }
    } on PostgrestException catch (error) {
      print('postgrest error');
      print(error);
      return Left(DatabaseFailure(errorMessage: 'Error updating customer'));
    } catch (e) {
      return Left(DatabaseFailure(errorMessage: 'Error updating customer'));
    }
  }
}
