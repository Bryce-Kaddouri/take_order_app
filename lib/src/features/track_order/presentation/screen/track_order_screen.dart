import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/order/presentation/provider/order_provider.dart';
import 'package:take_order_app/src/features/order/presentation/widget/order_item_view_by_status_widget.dart';

import '../../../order/data/model/order_model.dart';

class TrackOrderScreen extends StatefulWidget {
  final DateTime orderDate;
  const TrackOrderScreen({super.key, required this.orderDate});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen>
    with TickerProviderStateMixin {
  late AnimationController _controllerLeft;
  late AnimationController _controllerRight;

  final expanderKeyPending = GlobalKey<ExpanderState>(debugLabel: 'Pending');
  final expanderKeyCooking = GlobalKey<ExpanderState>(debugLabel: 'Cooking');
  final expanderKeyReady = GlobalKey<ExpanderState>(debugLabel: 'Ready');
  final expanderKeyCollected =
      GlobalKey<ExpanderState>(debugLabel: 'Collected');

  void toggle(GlobalKey<ExpanderState> key) {
    final open = key.currentState!.isExpanded;

    key.currentState!.isExpanded = !open;
  }

  @override
  void initState() {
    super.initState();
    _controllerLeft = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1,
    );
    _controllerRight = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.all(0),
      header: PageHeader(
        title: Container(
          height: 40,
          child: Row(
            children: [
              IconButton(
                icon: Icon(FluentIcons.back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text('Track Order'),
            ],
          ),
        ),
      ),
      content: FutureBuilder(
        future: context.read<OrderProvider>().getOrdersByDate(widget.orderDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ProgressRing(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final orders = snapshot.data as List<OrderModel>;
            List<OrderModel> pendingOrders = orders
                .where((element) => element.status.name == 'Pending')
                .toList();
            List<OrderModel> cookingOrders = orders
                .where((element) => element.status.name == 'Cooking')
                .toList();
            List<OrderModel> readyOrders = orders
                .where((element) => element.status.name == 'Ready')
                .toList();
            List<OrderModel> collectedOrders = orders
                .where((element) => element.status.name == 'Collected')
                .toList();
            return LayoutBuilder(
              builder: (context, constraints) {
                double calculatedHeight = constraints.maxHeight - 146;
                return Container(
                  height: constraints.maxHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 16, left: 16, right: 8, bottom: 16),
                          height: double.infinity,
                          child: Column(
                            children: [
                              Expander(
                                headerBackgroundColor: ButtonState.all(
                                  FluentTheme.of(context).menuColor,
                                ),
                                contentPadding: EdgeInsets.all(0),
                                animationDuration: Duration(milliseconds: 300),
                                key: expanderKeyPending,
                                initiallyExpanded: false,
                                direction: ExpanderDirection.down,
                                header: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Pending',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        height: 40,
                                        constraints: BoxConstraints(
                                          maxHeight: 40,
                                          minWidth: 40,
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${pendingOrders.length}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                content: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: calculatedHeight,
                                  ),
                                  child: pendingOrders.isEmpty
                                      ? Center(
                                          child: Text('No Pending Orders'),
                                        )
                                      : ListView.builder(
                                          itemCount: pendingOrders.length,
                                          itemBuilder: (context, index) {
                                            return OrdersItemViewByStatus(
                                                isTrackOrder: true,
                                                status: 'Pending',
                                                order: pendingOrders[index]);
                                          },
                                        ),
                                  /*height:
                                    calculatedHeight * _controllerLeft.value,*/
                                ),
                                onStateChanged: (open) {
                                  print(
                                      'state for cooking changed to open=$open');
                                  expanderKeyCooking.currentState!.isExpanded =
                                      !open;
                                  /* if (open) {
                                  _controllerLeft.forward();
                                } else {
                                  _controllerLeft.reverse();
                                }*/
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Expander(
                                headerBackgroundColor: ButtonState.all(
                                  FluentTheme.of(context).menuColor,
                                ),
                                key: expanderKeyCooking,
                                initiallyExpanded: true,
                                contentPadding: EdgeInsets.all(0),
                                animationDuration: Duration(milliseconds: 300),
                                direction: ExpanderDirection.down,
                                header: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Cooking',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        height: 40,
                                        constraints: BoxConstraints(
                                          maxHeight: 40,
                                          minWidth: 40,
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${cookingOrders.length}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                content: Container(
                                  /* height: calculatedHeight -
                                    (calculatedHeight * _controllerLeft.value),*/
                                  constraints: BoxConstraints(
                                    maxHeight: calculatedHeight,
                                  ),
                                  child: cookingOrders.isEmpty
                                      ? Center(
                                          child: Text('No Cooking Orders'),
                                        )
                                      : ListView.builder(
                                          itemCount: cookingOrders.length,
                                          itemBuilder: (context, index) {
                                            return OrdersItemViewByStatus(
                                                isTrackOrder: true,
                                                status: 'Cooking',
                                                order: cookingOrders[index]);
                                          },
                                        ),
                                ),
                                onStateChanged: (open) {
                                  print(
                                      'state for cooking changed to open=$open');
                                  expanderKeyPending.currentState!.isExpanded =
                                      !open;
                                  /*  if (open) {
                                  _controllerLeft.forward();
                                } else {
                                  _controllerLeft.reverse();
                                }*/
                                },
                              )
                            ],
                          ),
                        ),
                      ),

                      /// right side of the screen

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 16, left: 8, right: 16, bottom: 16),
                          height: double.infinity,
                          child: Column(
                            children: [
                              Expander(
                                headerBackgroundColor: ButtonState.all(
                                  FluentTheme.of(context).menuColor,
                                ),
                                contentPadding: EdgeInsets.all(0),
                                animationDuration: Duration(milliseconds: 300),
                                key: expanderKeyReady,
                                initiallyExpanded: true,
                                direction: ExpanderDirection.down,
                                header: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Ready',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        height: 40,
                                        constraints: BoxConstraints(
                                          maxHeight: 40,
                                          minWidth: 40,
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${readyOrders.length}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                content: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: calculatedHeight,
                                  ),
                                  child: readyOrders.isEmpty
                                      ? Center(
                                          child: Text('No Ready Orders'),
                                        )
                                      : ListView.builder(
                                          itemCount: readyOrders.length,
                                          itemBuilder: (context, index) {
                                            return OrdersItemViewByStatus(
                                                isTrackOrder: true,
                                                status: 'Ready',
                                                order: readyOrders[index]);
                                          },
                                        ),
                                ),
                                onStateChanged: (open) {
                                  print(
                                      'state for cooking changed to open=$open');
                                  expanderKeyCollected
                                      .currentState!.isExpanded = !open;
                                  /* if (open) {
                                  _controllerLeft.forward();
                                } else {
                                  _controllerLeft.reverse();
                                }*/
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Expander(
                                headerBackgroundColor: ButtonState.all(
                                  FluentTheme.of(context).menuColor,
                                ),
                                key: expanderKeyCollected,
                                initiallyExpanded: false,
                                contentPadding: EdgeInsets.all(0),
                                animationDuration: Duration(milliseconds: 300),
                                header: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Collected',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Container(
                                        height: 40,
                                        constraints: BoxConstraints(
                                          maxHeight: 40,
                                          minWidth: 40,
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${cookingOrders.length}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                content: Container(
                                  /* height: calculatedHeight -
                                    (calculatedHeight * _controllerLeft.value),*/
                                  constraints: BoxConstraints(
                                    maxHeight: calculatedHeight,
                                  ),
                                  child: collectedOrders.isEmpty
                                      ? Center(
                                          child: Text('No Collected Orders'),
                                        )
                                      : ListView.builder(
                                          itemCount: collectedOrders.length,
                                          itemBuilder: (context, index) {
                                            return OrdersItemViewByStatus(
                                                isTrackOrder: true,
                                                status: 'Collected',
                                                order: collectedOrders[index]);
                                          },
                                        ),
                                ),
                                onStateChanged: (open) {
                                  print(
                                      'state for cooking changed to open=$open');
                                  expanderKeyReady.currentState!.isExpanded =
                                      !open;
                                  /*  if (open) {
                                  _controllerLeft.forward();
                                } else {
                                  _controllerLeft.reverse();
                                }*/
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
