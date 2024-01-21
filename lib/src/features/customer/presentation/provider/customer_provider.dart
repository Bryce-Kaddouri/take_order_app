import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_add_customer_usecase.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_update_customer_usecase.dart';
import 'package:take_order_app/src/features/customer/data/datasource/customer_datasource.dart';

import '../../../../core/data/usecase/usecase.dart';

import '../../business/usecase/customer_get_customer_by_id_usecase.dart';
import '../../business/usecase/customer_get_customers_usecase.dart';

import '../../data/model/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerGetCustomersUseCase customerGetCustomersUseCase;
  final CustomerGetCustomerByIdUseCase customerGetCustomersByIdUseCase;
  final CustomerAddCustomerUseCase customerAddCustomerUseCase;
  final CustomerUpdateCustomerUseCase customerUpdateCustomerUseCase;

  CustomerProvider({
    required this.customerGetCustomersUseCase,
    required this.customerGetCustomersByIdUseCase,
    required this.customerAddCustomerUseCase,
    required this.customerUpdateCustomerUseCase,
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  CustomerModel? _customerModel;

  CustomerModel? get customerModel => _customerModel;

  void setProductModel(CustomerModel? value) {
    _customerModel = value;
    notifyListeners();
  }

  String _searchText = '';

  String get searchText => _searchText;

  void setSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  void setTextController(String value) {
    _searchController.text = value;
    notifyListeners();
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    CustomerModel? customerModel;
    final result = await customerGetCustomersByIdUseCase.call(id);

    await result.fold((l) async {
      print(l.errorMessage);
    }, (r) async {
      print(r.toJson());
      customerModel = r;
    });

    return customerModel;
  }

  Future getCustomerInfoById(int customerId) async {
    var res = null;
    final result = await CustomerDataSource().getCustomerInfosById(customerId);
    await result.fold((l) async {
      print("error");
      print(l.errorMessage);
    }, (r) async {
      print("result");
      print(r);
      res = r;
    });

    return res;

  }

  Future<CustomerModel?> addCustomer(String fName, String lName, String phoneNumber, BuildContext context) async {
    CustomerModel customerModelParam = CustomerModel(
      phoneNumber: phoneNumber, id: null, fName: fName, lName: lName,
    );
    CustomerModel? customerModelResponse;
    final result = await customerAddCustomerUseCase.call(customerModelParam);

    await result.fold((l) async {
      print(l.errorMessage);
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          onVisible: () {
            Future.delayed(const Duration(seconds: 2), () {
              // dismiss banner
              ScaffoldMessenger.of(context)
                  .hideCurrentMaterialBanner();
            });
          },
          content: Text(
            l.errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .hideCurrentMaterialBanner();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

    }, (CustomerModel r) async {
      print(r.toJson());
      customerModelResponse = r;
    });

    return customerModelResponse;
  }

  Future<CustomerModel?> updateCustomer(String fName, String lName, String phoneNumber, BuildContext context) async {
    CustomerModel customerModelParam = CustomerModel(
      phoneNumber: phoneNumber, id: _customerModel?.id, fName: fName, lName: lName,
    );
    CustomerModel? customerModelResponse;
    final result = await customerUpdateCustomerUseCase.call(customerModelParam);

    await result.fold((l) async {
      print(l.errorMessage);
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          onVisible: () {
            Future.delayed(const Duration(seconds: 2), () {
              // dismiss banner
              ScaffoldMessenger.of(context)
                  .hideCurrentMaterialBanner();
            });
          },
          content: Text(
            l.errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .hideCurrentMaterialBanner();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

    }, (CustomerModel r) async {
      print(r.toJson());
      customerModelResponse = r;
    });

    return customerModelResponse;
  }

  Future<List<CustomerModel>?> getCustomers() async {
    List<CustomerModel>? customerModelList;
    final result = await customerGetCustomersUseCase.call(NoParams());

    await result.fold((l) async {

    }, (r) async {
      print('result');
      print(r);
      customerModelList = r;
    });

    return customerModelList;
  }
}
