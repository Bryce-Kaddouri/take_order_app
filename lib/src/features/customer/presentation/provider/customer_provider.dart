import 'package:fluent_ui/fluent_ui.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_add_customer_usecase.dart';
import 'package:take_order_app/src/features/customer/business/usecase/customer_update_customer_usecase.dart';

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

  bool _searchIsVisible = false;
  bool get searchIsVisible => _searchIsVisible;
  void setSearchIsVisible(bool value) {
    _searchIsVisible = value;
    notifyListeners();
  }

  bool _isEditingCustomer = false;
  bool get isEditingCustomer => _isEditingCustomer;
  void setIsEditingCustomer(bool value) {
    _isEditingCustomer = value;
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

  /*Future getCustomerInfoById(int customerId) async {
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

  }*/

  Future<bool> addCustomer(String fName, String lName, String phoneNumber, String countryCode, BuildContext context) async {
    CustomerModel customerModelParam = CustomerModel(
      phoneNumber: phoneNumber,
      id: null,
      fName: fName,
      lName: lName,
      countryCode: countryCode,
    );
    bool isSuccess = false;
    final result = await customerAddCustomerUseCase.call(customerModelParam);

    await result.fold((l) async {
      print(l.errorMessage);
      displayInfoBar(alignment: Alignment.topRight, context, builder: (context, close) {
        return InfoBar(
          title: const Text('Error!'),
          content: Container(
            width: 200.0,
            child: Text(l.errorMessage),
          ),
          severity: InfoBarSeverity.error,
          isLong: false,
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
        );
      });
    }, (CustomerModel r) async {
      print(r.toJson());
      displayInfoBar(alignment: Alignment.topRight, context, builder: (context, close) {
        return InfoBar(
          title: const Text('Success!'),
          content: Container(
            width: 150.0,
            child: const Text('Customer added successfully'),
          ),
          severity: InfoBarSeverity.success,
          isLong: false,
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
        );
      });
      isSuccess = true;
    });

    return isSuccess;
  }

  Future<bool> updateCustomer(int customerId, String fName, String lName, String phoneNumber, String countryCode, BuildContext context) async {
    CustomerModel customerModelParam = CustomerModel(
      phoneNumber: phoneNumber,
      id: customerId,
      fName: fName,
      lName: lName,
      countryCode: countryCode,
    );
    bool isSuccess = false;
    final result = await customerUpdateCustomerUseCase.call(customerModelParam);

    await result.fold((l) async {
      print('failed');
      print(l.errorMessage);
      displayInfoBar(alignment: Alignment.topRight, context, builder: (context, close) {
        return InfoBar(
          title: const Text('Error!'),
          content: Container(
            width: 200.0,
            child: Text(l.errorMessage),
          ),
          severity: InfoBarSeverity.error,
          isLong: false,
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
        );
      });
    }, (bool r) async {
      print('success');
      displayInfoBar(alignment: Alignment.topRight, context, builder: (context, close) {
        return InfoBar(
          title: const Text('Success!'),
          content: Container(
            width: 150.0,
            child: const Text('Customer updated successfully'),
          ),
          severity: InfoBarSeverity.success,
          isLong: false,
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
        );
      });
      isSuccess = true;
    });

    return isSuccess;
  }

  Future<List<CustomerModel>?> getCustomers() async {
    List<CustomerModel>? customerModelList;
    final result = await customerGetCustomersUseCase.call(NoParams());

    await result.fold((l) async {}, (r) async {
      print('result');
      print(r);
      customerModelList = r;
    });

    return customerModelList;
  }
}
