import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/order/data/datasource/datasource.dart';

import '../../data/model/customer_model.dart';
import '../provider/customer_provider.dart';

class CustomerDetailScreen extends StatelessWidget {
  final int id;
  CustomerDetailScreen({required this.id});

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: Future.wait([
                context.read<CustomerProvider>().getCustomerById(id),
                OrderDataSource().getOrders(),


            ]),
              builder: (context, snapshot) {
/*
                print(snapshot.data);
*/
                if (snapshot.hasData) {
                  print('-' * 50 );
                  print(snapshot.data);
                  print('-' * 50 );
                 /*CustomerModel customerModel = snapshot.data[0];
                  print(customerModel.fName);*/
                  return Column(
                    children: [
                     /* Text(snapshot.data!.fName),
                      Text(snapshot.data!.lName),
                      Text(snapshot.data!.phoneNumber),*/
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
