import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  bool pendingOpen = false;
  final expanderKeyCooking = GlobalKey<ExpanderState>(debugLabel: 'Cooking');
  bool cookingOpen = true;
  final expanderKeyReady = GlobalKey<ExpanderState>(debugLabel: 'Ready');
  bool readyOpen = true;
  final expanderKeyCollected = GlobalKey<ExpanderState>(debugLabel: 'Collected');
  bool collectedOpen = false;

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

    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        expanderKeyPending.currentState!.isExpanded = false;
        expanderKeyCooking.currentState!.isExpanded = false;
        expanderKeyReady.currentState!.isExpanded = false;
        expanderKeyCollected.currentState!.isExpanded = false;
      }
    });*/

    Supabase.instance.client
        .channel('all_orders_view')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'orders',
            callback: (payload) async {
              print(' ------------------- payload order-------------------');
              print(payload);
              print(' ------------------- payload -------------------');

              if (DateTime.parse(payload.newRecord['date']) == widget.orderDate) {
                setState(() {});
              }
            })
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      /*  header: Container(
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
      ),*/
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
        title: Row(
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
        actions: [
          Button(
            style: ButtonStyle(
              padding: ButtonState.all(EdgeInsets.zero),
            ),
            child: Container(
              height: 40,
              width: 40,
              child: Icon(FluentIcons.event_date, size: 20),
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
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: FutureBuilder(
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
                                      isOpen: pendingOpen,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CookingListViewWidget(
                                      expanderKeyCooking: expanderKeyCooking,
                                      expanderKeyPending: expanderKeyPending,
                                      cookingOrders: cookingOrders,
                                      calculatedHeight: calculatedHeight,
                                      isOpen: cookingOpen,
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
                                      isOpen: readyOpen,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CollectedListViewWidget(
                                      expanderKeyCollected: expanderKeyCollected,
                                      expanderKeyReady: expanderKeyReady,
                                      collectedOrders: collectedOrders,
                                      calculatedHeight: calculatedHeight,
                                      isOpen: collectedOpen,
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
                        isOpen: true,
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
                        isOpen: true,
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
                        isOpen: true,
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
                        isOpen: true,
                      ),
                    ],
                  );
          }
        },
      ),
    );
  }
}

class PendingListViewWidget extends StatefulWidget {
  final GlobalKey<ExpanderState> expanderKeyPending;
  final GlobalKey<ExpanderState> expanderKeyCooking;
  final List<OrderModel> pendingOrders;
  final double calculatedHeight;
  final bool isMobile;
  bool isOpen;
  PendingListViewWidget({super.key, required this.expanderKeyPending, required this.expanderKeyCooking, required this.pendingOrders, required this.calculatedHeight, this.isMobile = false, required this.isOpen});

  @override
  State<PendingListViewWidget> createState() => _PendingListViewWidgetState();
}

class _PendingListViewWidgetState extends State<PendingListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      headerBackgroundColor: ButtonState.all(
        FluentTheme.of(context).menuColor,
      ),
      contentPadding: EdgeInsets.all(0),
      animationDuration: Duration(milliseconds: 300),
      key: widget.expanderKeyPending,
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
                '${widget.pendingOrders.length}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        height: widget.isMobile
            ? null
            : widget.isOpen
                ? widget.calculatedHeight
                : 0,
        constraints: widget.isMobile
            ? null
            : BoxConstraints(
                maxHeight: widget.calculatedHeight,
              ),
        child: widget.pendingOrders.isEmpty
            ? Center(
                child: Text('No Pending Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: widget.isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: widget.pendingOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: 'Pending', order: widget.pendingOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!widget.isMobile) {
          widget.expanderKeyCooking.currentState!.isExpanded = !open;
          setState(() {
            widget.isOpen = open;
          });
        }
      },
    );
  }
}

class CookingListViewWidget extends StatefulWidget {
  final GlobalKey<ExpanderState> expanderKeyCooking;
  final GlobalKey<ExpanderState> expanderKeyPending;
  final List<OrderModel> cookingOrders;
  final double calculatedHeight;
  final bool isMobile;
  bool isOpen;

  CookingListViewWidget({super.key, required this.expanderKeyCooking, required this.expanderKeyPending, required this.cookingOrders, required this.calculatedHeight, this.isMobile = false, required this.isOpen});

  @override
  State<CookingListViewWidget> createState() => _CookingListViewWidgetState();
}

class _CookingListViewWidgetState extends State<CookingListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      headerBackgroundColor: ButtonState.all(
        FluentTheme.of(context).menuColor,
      ),
      key: widget.expanderKeyCooking,
      initiallyExpanded: widget.isMobile ? false : true,
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
                '${widget.cookingOrders.length}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        height: widget.isMobile
            ? null
            : widget.isOpen
                ? widget.calculatedHeight
                : 0,
        constraints: widget.isMobile
            ? null
            : BoxConstraints(
                maxHeight: widget.calculatedHeight,
              ),
        child: widget.cookingOrders.isEmpty
            ? Center(
                child: Text('No Cooking Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: widget.isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: widget.cookingOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: 'Cooking', order: widget.cookingOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!widget.isMobile) {
          widget.expanderKeyPending.currentState!.isExpanded = !open;
          setState(() {
            widget.isOpen = open;
          });
        }
      },
    );
  }
}

class ReadyListViewWidget extends StatefulWidget {
  final GlobalKey<ExpanderState> expanderKeyReady;
  final GlobalKey<ExpanderState> expanderKeyCollected;
  final List<OrderModel> readyOrders;
  final double calculatedHeight;
  final bool isMobile;
  bool isOpen;

  ReadyListViewWidget({super.key, required this.expanderKeyReady, required this.expanderKeyCollected, required this.readyOrders, required this.calculatedHeight, this.isMobile = false, required this.isOpen});

  @override
  State<ReadyListViewWidget> createState() => _ReadyListViewWidgetState();
}

class _ReadyListViewWidgetState extends State<ReadyListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      headerBackgroundColor: ButtonState.all(
        FluentTheme.of(context).menuColor,
      ),
      contentPadding: EdgeInsets.all(0),
      animationDuration: Duration(milliseconds: 300),
      key: widget.expanderKeyReady,
      initiallyExpanded: widget.isMobile ? false : true,
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
                '${widget.readyOrders.length}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        height: widget.isMobile
            ? null
            : widget.isOpen
                ? widget.calculatedHeight
                : 0,
        constraints: widget.isMobile
            ? null
            : BoxConstraints(
                maxHeight: widget.calculatedHeight,
              ),
        child: widget.readyOrders.isEmpty
            ? Center(
                child: Text('No Ready Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: widget.isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: widget.readyOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: widget.readyOrders[index].status.name, order: widget.readyOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!widget.isMobile) {
          widget.expanderKeyCollected.currentState!.isExpanded = !open;
          setState(() {
            widget.isOpen = open;
          });
        }
      },
    );
  }
}

class CollectedListViewWidget extends StatefulWidget {
  final GlobalKey<ExpanderState> expanderKeyCollected;
  final GlobalKey<ExpanderState> expanderKeyReady;
  final List<OrderModel> collectedOrders;
  final double calculatedHeight;
  final bool isMobile;
  bool isOpen;

  CollectedListViewWidget({super.key, required this.expanderKeyCollected, required this.expanderKeyReady, required this.collectedOrders, required this.calculatedHeight, this.isMobile = false, required this.isOpen});

  @override
  State<CollectedListViewWidget> createState() => _CollectedListViewWidgetState();
}

class _CollectedListViewWidgetState extends State<CollectedListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Expander(
      headerBackgroundColor: ButtonState.all(
        FluentTheme.of(context).menuColor,
      ),
      initiallyExpanded: false,
      key: widget.expanderKeyCollected,
/*
      initiallyExpanded: false,
*/
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
                '${widget.collectedOrders.length}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        height: widget.isMobile
            ? null
            : widget.isOpen
                ? widget.calculatedHeight
                : 0,
        padding: EdgeInsets.all(16),
        constraints: widget.isMobile
            ? null
            : BoxConstraints(
                maxHeight: widget.calculatedHeight,
              ),
        child: widget.collectedOrders.isEmpty
            ? Center(
                child: Text('No Collected Orders'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: widget.isMobile ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                itemCount: widget.collectedOrders.length,
                itemBuilder: (context, index) {
                  return OrdersItemViewByStatus(isTrackOrder: true, status: 'Collected', order: widget.collectedOrders[index]);
                },
              ),
      ),
      onStateChanged: (open) {
        print('state for cooking changed to open=$open');
        if (!widget.isMobile) {
          widget.expanderKeyReady.currentState!.isExpanded = !open;
          setState(() {
            widget.isOpen = open;
          });
        }
      },
    );
  }
}
