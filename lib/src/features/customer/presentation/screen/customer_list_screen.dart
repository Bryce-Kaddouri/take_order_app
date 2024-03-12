import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/model/customer_model.dart';
import '../provider/customer_provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.all(0),
      header: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            FilledButton(
              style: ButtonStyle(
                padding: ButtonState.all(EdgeInsets.all(0)),
              ),
              onPressed: () {
                context.go('/orders');
              },
              child: Container(
                height: 40,
                width: 40,
                child: Icon(FluentIcons.back),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 60),
                alignment: Alignment.center,
                child: Text(
                  'Customers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      content: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              floating: true,
              delegate: SearchBarDelegate(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: TextBox(
                    controller: context.read<CustomerProvider>().searchController,
                    placeholder: 'Search Customer ...',
                    prefix: Icon(FluentIcons.search),
                    suffix: IconButton(
                      icon: Icon(FluentIcons.clear),
                      onPressed: () {
                        context.read<CustomerProvider>().searchController.clear();
                        context.read<CustomerProvider>().setSearchText('');
                      },
                    ),
                    onChanged: (value) {
                      context.read<CustomerProvider>().setSearchText(value);
                    },
                  ),
                ),
              )),
          SliverToBoxAdapter(
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
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          onPressed: () {
                            context.go('/customers/${snapshot.data![index].id}');
                          },
                          leading: CircleAvatar(backgroundColor: Colors.blue, foregroundColor: Colors.white, child: Text(snapshot.data?[index].fName?[0] ?? '')),
                          title: Text(snapshot.data?[index].fName ?? ''),
                          subtitle: Text(snapshot.data?[index].lName ?? ''),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: ProgressRing());
              },
            ),
          ),
        ],
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
