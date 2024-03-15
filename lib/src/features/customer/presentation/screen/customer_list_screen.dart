import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/auth/presentation/screen/signin_screen.dart';

import '../../data/model/customer_model.dart';
import '../provider/customer_provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
      appBar: material.AppBar(
        leading: material.BackButton(
          onPressed: () async {
            context.go('/');
          },
        ),
        centerTitle: true,
        shadowColor: FluentTheme.of(context).shadowColor,
        surfaceTintColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        elevation: 4,
        title: context.watch<CustomerProvider>().searchIsVisible
            ? Container(
                height: 40,
                child: TextBox(
                  controller: context.read<CustomerProvider>().searchController,
                  placeholder: 'Search Customer ...',
                  prefix: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(FluentIcons.search),
                  ),
                  suffix: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(FluentIcons.clear),
                    ),
                    onPressed: () {
                      context.read<CustomerProvider>().searchController.clear();
                      context.read<CustomerProvider>().setSearchText('');
                    },
                  ),
                  onChanged: (value) {
                    context.read<CustomerProvider>().setSearchText(value);
                  },
                ),
              )
            : const Text('Customers'),
        actions: [
          Button(
            style: ButtonStyle(
              padding: ButtonState.all(EdgeInsets.zero),
            ),
            child: Container(
              height: 40,
              width: 40,
              child: context.read<CustomerProvider>().searchIsVisible ? Icon(FluentIcons.clear) : Icon(FluentIcons.search),
            ),
            onPressed: () {
              context.read<CustomerProvider>().setSearchIsVisible(!context.read<CustomerProvider>().searchIsVisible);
            },
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: DismissKeyboard(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: FutureBuilder<List<CustomerModel>?>(
            future: context.read<CustomerProvider>().getCustomers(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              print('data');
              print(snapshot.data);
              if (snapshot.hasData) {
                List<CustomerModel>? customerList = snapshot.data;
                customerList = customerList?.where((element) {
                  String fullName = '${element.fName!} ${element.lName!}';
                  return fullName.toLowerCase().contains(context.watch<CustomerProvider>().searchText.toLowerCase());
                }).toList();
                print('customerList');
                if (customerList?.isEmpty ?? true) {
                  return const Center(child: Text('No Customers'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: customerList?.length,
                  itemBuilder: (context, index) {
                    return Card(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        onPressed: () {
                          context.go('/customers/${snapshot.data![index].id}');
                        },
                        leading: CircleAvatar(
                            /*  backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,*/
                            child: Text(snapshot.data?[index].fName?[0] ?? '')),
                        title: Text(snapshot.data?[index].fName ?? ''),
                        subtitle: Text(snapshot.data?[index].lName ?? ''),
                        trailing: Icon(FluentIcons.chevron_right),
                      ),
                    );
                  },
                );
              }
              return const Center(child: ProgressRing());
            },
          ),
        ),
      ),
    );
    /*Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:  BackButton(
          onPressed: (){
            context.go('/orders');
          },
        ),
        centerTitle: true,
        title: const Text('Customers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSearchBar(
              controller: context.read<CustomerProvider>().searchController,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              searchStyle: const TextStyle(
                color: Colors.black,
              ),
              cursorColor: Colors.white,
              searchDecoration:  InputDecoration(
                hintText: "Search Customer ...",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),

              onChanged: (value) {
                context.read<CustomerProvider>().setSearchText(value);
              },
            ),
          ),
        )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: FutureBuilder<List<CustomerModel>?>(
              future: context.read<CustomerProvider>().getCustomers(),
              builder: (context, snapshot) {
                print(snapshot.connectionState);
                print('data');
                print(snapshot.data);
                if (snapshot.hasData) {
                  List<CustomerModel>? customerList = snapshot.data;
                  customerList = customerList?.where((element) {
                    String fullName = '${element.fName!} ${element.lName!}';
                    return fullName.toLowerCase().contains(context.watch<CustomerProvider>().searchText.toLowerCase());
                  }
                  ).toList();
                  print('customerList');
                  if(customerList?.isEmpty ?? true) {
                    return const Center(child: Text('No Customers'));
                  }
                  return ListView.builder(
                    itemCount: customerList?.length,
                    itemBuilder: (context, index) {
                      return Card(child:ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          child: Text(snapshot.data?[index].fName?[0] ?? '')
                        ),
                        title: Text(snapshot.data?[index].fName ?? ''),
                        subtitle: Text(snapshot.data?[index].lName ?? ''),
                        onTap: () {
                          context.goNamed('customer-details', pathParameters: {'id': snapshot.data![index].id.toString()});
                        },
                      ),);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),

      ),

    );*/
  }
}

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SearchBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
