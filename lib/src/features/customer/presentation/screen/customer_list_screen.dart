import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/model/customer_model.dart';
import '../provider/customer_provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
            ),
            Expanded(child: FutureBuilder<List<CustomerModel>?>(
              future: context.read<CustomerProvider>().getCustomers(),
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                print('data');
                print(snapshot.data);
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data?[index].fName ?? ''),
                        subtitle: Text(snapshot.data?[index].lName ?? ''),
                        onTap: () {
                          context.go('/customers/${snapshot.data?[index].id}');
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add-customer');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}