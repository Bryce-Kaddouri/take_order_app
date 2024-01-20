import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            FutureBuilder<CustomerModel?>(
              future: context.read<CustomerProvider>().getCustomerById(id),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.fName),
                      Text(snapshot.data!.lName),
                      Text(snapshot.data!.phoneNumber),
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
