import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/core/helper/responsive_helper.dart';
import 'package:take_order_app/src/features/order/presentation/provider/order_provider.dart';
import 'package:take_order_app/src/features/order/presentation/widget/order_item_view_by_status_widget.dart';

import '../../../../core/constant/app_color.dart';
import '../../../order/data/model/order_model.dart';

class TrackOrderScreen extends StatefulWidget {
  final DateTime orderDate;
  const TrackOrderScreen({super.key, required this.orderDate});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> with TickerProviderStateMixin {
  late AnimationController _controllerLeft;
  late AnimationController _controllerRight;

  final expanderKeyPending = GlobalKey<ExpanderState>(debugLabel: 'Pending');
  final expanderKeyCooking = GlobalKey<ExpanderState>(debugLabel: 'Cooking');
  final expanderKeyReady = GlobalKey<ExpanderState>(debugLabel: 'Ready');
  final expanderKeyCollected = GlobalKey<ExpanderState>(debugLabel: 'Collected');

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
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.streaming, size: 24),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      DateHelper.getFormattedDateWithoutTime(widget.orderDate, isShort: ResponsiveHelper.isMobile(context)),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            FilledButton(
              style: ButtonStyle(
                padding: ButtonState.all(EdgeInsets.all(0)),
              ),
              onPressed: () {
                material
                    .showDatePicker(
                  context: context,
                  currentDate: DateTime.now(),
                  initialDate: widget.orderDate,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                )
                    .then((value) {
                  if (value != null) {
                    String orderDate = DateHelper.getFormattedDate(value);
                    context.go('/track-order/$orderDate');
                  }
                });
              },
              child: Container(
                height: 40,
                width: 40,
                child: Icon(FluentIcons.event_date, size: 24),
              ),
            ),
            SizedBox(
              width: 8,
            ),
          ],
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
            List<OrderModel> pendingOrders = orders.where((element) => element.status.name == 'Pending').toList();
            List<OrderModel> cookingOrders = orders.where((element) => element.status.name == 'Cooking').toList();
            List<OrderModel> readyOrders = orders.where((element) => element.status.name == 'Completed').toList();
            List<OrderModel> collectedOrders = orders.where((element) => element.status.name == 'Collected').toList();
            return !ResponsiveHelper.isMobile(context)
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      double calculatedHeight = constraints.maxHeight - 146;
                      return Container(
                        height: constraints.maxHeight,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 16, left: 16, right: 8, bottom: 16),
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    PendingListViewWidget(
                                      expanderKeyPending: expanderKeyPending,
                                      expanderKeyCooking: expanderKeyCooking,
                                      pendingOrders: pendingOrders,
                                      calculatedHeight: calculatedHeight,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CookingListViewWidget(
                                      expanderKeyCooking: expanderKeyCooking,
                                      expanderKeyPending: expanderKeyPending,
                                      cookingOrders: cookingOrders,
                                      calculatedHeight: calculatedHeight,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// right side of the screen

                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 16, left: 8, right: 16, bottom: 16),
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    ReadyListViewWidget(
                                      expanderKeyReady: expanderKeyReady,
                                      expanderKeyCollected: expanderKeyCollected,
                                      readyOrders: readyOrders,
                                      calculatedHeight: calculatedHeight,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CollectedListViewWidget(
                                      expanderKeyCollected: expanderKeyCollected,
                                      expanderKeyReady: expanderKeyReady,
                                      collectedOrders: collectedOrders,
                                      calculatedHeight: calculatedHeight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    children: [
                      PendingListViewWidget(
                        expanderKeyPending: expanderKeyPending,
                        expanderKeyCooking: expanderKeyCooking,
                        pendingOrders: pendingOrders,
                        calculatedHeight: 300,
                        isMobile: true,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CookingListViewWidget(
                        expanderKeyCooking: expanderKeyCooking,
                        expanderKeyPending: expanderKeyPending,
                        cookingOrders: cookingOrders,
                        calculatedHeight: 300,
                        isMobile: true,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ReadyListViewWidget(
                        expanderKeyReady: expanderKeyReady,
                        expanderKeyCollected: expanderKeyCollected,
                        readyOrders: readyOrders,
                        calculatedHeight: 300,
                        isMobile: true,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CollectedListViewWidget(
                        expanderKeyCollected: expanderKeyCollected,
                        expanderKeyReady: expanderKeyReady,
                        collectedOrders: collectedOrders,
                        calculatedHeight: 300,
                        isMobile: true,
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}

class PendingListViewWidget extends StatelessWidget {
  final GlobalKey<ExpanderState> expanderKeyPending;
  final GlobalKey<ExpanderState> expanderKeyCooking;
  final List<OrderModel> pendingOrders;
  final double calculatedHeight;
  final bool isMobile;
  const PendingListViewWidget({super.key, required this.expanderKeyPending, required this.expanderKeyCooking, required this.pendingOrders, required this.calculatedHeight, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Expander(
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
                color: AppColor.pendingForegroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${pendingOrders.length}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        constraints: isMobile
            ? null
            : BoxConstraints(
                minHeight: calculatedHeight,
                maxHeight: calculatedHeight,
              ),
        child: pendingOrders.isEmpty
            ? Center(
                child: Text('No Pending Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: pendingOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: 'Pending', order: pendingOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!isMobile) {
          expanderKeyCooking.currentState!.isExpanded = !open;
        }
      },
    );
  }
}

class CookingListViewWidget extends StatelessWidget {
  final GlobalKey<ExpanderState> expanderKeyCooking;
  final GlobalKey<ExpanderState> expanderKeyPending;
  final List<OrderModel> cookingOrders;
  final double calculatedHeight;
  final bool isMobile;

  const CookingListViewWidget({super.key, required this.expanderKeyCooking, required this.expanderKeyPending, required this.cookingOrders, required this.calculatedHeight, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Expander(
      headerBackgroundColor: ButtonState.all(
        FluentTheme.of(context).menuColor,
      ),
      key: expanderKeyCooking,
      initiallyExpanded: isMobile ? false : true,
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
                color: AppColor.cookingForegroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${cookingOrders.length}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        constraints: isMobile
            ? null
            : BoxConstraints(
                minHeight: calculatedHeight,
                maxHeight: calculatedHeight,
              ),
        child: cookingOrders.isEmpty
            ? Center(
                child: Text('No Cooking Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: cookingOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: 'Cooking', order: cookingOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!isMobile) {
          expanderKeyPending.currentState!.isExpanded = !open;
        }
      },
    );
  }
}

class ReadyListViewWidget extends StatelessWidget {
  final GlobalKey<ExpanderState> expanderKeyReady;
  final GlobalKey<ExpanderState> expanderKeyCollected;
  final List<OrderModel> readyOrders;
  final double calculatedHeight;
  final bool isMobile;

  const ReadyListViewWidget({super.key, required this.expanderKeyReady, required this.expanderKeyCollected, required this.readyOrders, required this.calculatedHeight, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Expander(
      headerBackgroundColor: ButtonState.all(
        FluentTheme.of(context).menuColor,
      ),
      contentPadding: EdgeInsets.all(0),
      animationDuration: Duration(milliseconds: 300),
      key: expanderKeyReady,
      initiallyExpanded: isMobile ? false : true,
      direction: ExpanderDirection.down,
      header: Container(
        alignment: Alignment.center,
        height: 50,
        child: Row(
          children: [
            Text(
              'Completed',
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
                color: AppColor.completedForegroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${readyOrders.length}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        constraints: isMobile
            ? null
            : BoxConstraints(
                minHeight: calculatedHeight,
                maxHeight: calculatedHeight,
              ),
        child: readyOrders.isEmpty
            ? Center(
                child: Text('No Ready Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: readyOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: readyOrders[index].status.name, order: readyOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!isMobile) {
          expanderKeyCollected.currentState!.isExpanded = !open;
        }
      },
    );
  }
}

class CollectedListViewWidget extends StatelessWidget {
  final GlobalKey<ExpanderState> expanderKeyCollected;
  final GlobalKey<ExpanderState> expanderKeyReady;
  final List<OrderModel> collectedOrders;
  final double calculatedHeight;
  final bool isMobile;

  const CollectedListViewWidget({super.key, required this.expanderKeyCollected, required this.expanderKeyReady, required this.collectedOrders, required this.calculatedHeight, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Expander(
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
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${collectedOrders.length}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        constraints: isMobile
            ? null
            : BoxConstraints(
                minHeight: calculatedHeight,
                maxHeight: calculatedHeight,
              ),
        child: collectedOrders.isEmpty
            ? Center(
                child: Text('No Collected Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: collectedOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: 'Collected', order: collectedOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!isMobile) {
          expanderKeyReady.currentState!.isExpanded = !open;
        }
      },
    );
  }
}
