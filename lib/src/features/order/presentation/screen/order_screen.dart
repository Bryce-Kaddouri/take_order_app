import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/features/order/presentation/widget/drawer_widget.dart';

import '../../data/model/order_model.dart';
import '../provider/order_provider.dart';
import '../widget/date_item_widget.dart';
import '../widget/order_item_view_by_status_widget.dart';

class OrderScreen extends StatefulWidget {
  final DateTime selectedDate;
  const OrderScreen({super.key, required this.selectedDate});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

// keep alive mixin
class _OrderScreenState extends State<OrderScreen> with AutomaticKeepAliveClientMixin {
  ScrollController _mainScrollController = ScrollController();
  ScrollController _testController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  Future<DateTime?> selectDate() async {
    // global key for the form
    return material.showDatePicker(
        context: context,
        currentDate: widget.selectedDate,
        initialDate: widget.selectedDate,
        // first date of the year
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

  @override
  Widget build(BuildContext context) {
    print('order screen');
    print(widget.selectedDate);
    return material.Scaffold(
      appBar: material.AppBar(
        surfaceTintColor: FluentTheme.of(context).inactiveBackgroundColor,
        backgroundColor: FluentTheme.of(context).inactiveBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateHelper.getMonthNameAndYear(widget.selectedDate)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              DateTime now = DateTime.now();
              String date = DateHelper.getFormattedDate(now);
              context.go('/orders/$date');
            },
            icon: const Icon(FluentIcons.goto_today, size: 30),
          ),
          IconButton(
            onPressed: () async {
              await selectDate().then((value) {
                if (value != null) {
                  context.go('/orders/${DateHelper.getFormattedDate(value)}');
                }
              });
            },
            icon: const Icon(FluentIcons.event_date, size: 30),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      drawer: DrawerWidget(
        orderDate: widget.selectedDate,
      ),
      body: CustomScrollView(controller: _mainScrollController, slivers: [
        material.SliverPersistentHeader(
          floating: true,
          delegate: HeaderDelegate(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [
                    0.0,
                    0.9,
                    0.9,
                    1.0,
                  ],
                  colors: [
                    FluentTheme.of(context).inactiveBackgroundColor,
                    FluentTheme.of(context).inactiveBackgroundColor,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              width: double.infinity,
              child: Row(
                children: List.generate(
                  DateHelper.getDaysInWeek(widget.selectedDate).length,
                  (index) {
                    DateTime dateItem = DateHelper.getDaysInWeek(widget.selectedDate)[index];
                    print('test: ' + index.toString());
                    print(dateItem);
                    bool isToday = widget.selectedDate.year == dateItem.year && widget.selectedDate.month == dateItem.month && widget.selectedDate.day == dateItem.day;

                    return Expanded(
                      child: DateItemWidget(
                        selectedDate: widget.selectedDate,
                        dateItem: dateItem,
                        isToday: isToday,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: context.read<OrderProvider>().getOrdersByDate(widget.selectedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> lstHourMap = [];

                List<OrderModel> orderList = snapshot.data as List<OrderModel>;
                List<int> lstHourDistinct = orderList.map((e) => e.time.hour).toSet().toList();
                print('order list length');
                print(orderList.length);

                for (var hour in lstHourDistinct) {
                  List<OrderModel> orderListOfTheHour = orderList.where((element) => element.time.hour == hour).toList();

                  Map<String, dynamic> map = {
                    'hour': hour,
                    'order': orderListOfTheHour,
                  };
                  lstHourMap.add(map);
                }

                if (lstHourMap.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text("No order found for this date"),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Map<String, dynamic> data = lstHourMap[index];
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: Expander(
                          header: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${DateHelper.get24HourTime(material.TimeOfDay(hour: data['hour'], minute: 0))}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${data['order'].length}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' orders',
                                  ),
                                ],
                              ))
                            ],
                          ),
                          content: Column(
                            children: List.generate(
                              data['order'].length,
                              (index) => OrdersItemViewByStatus(
                                status: data['order'][index].status.name,
                                order: data['order'][index],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: lstHourDistinct.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("No order"),
                  ),
                );
              }
            } else {
              return SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ProgressRing(),
                ),
              );
            }
          },
        )
      ]),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}

class HorizontalSliverList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets listPadding;
  final Widget? divider;

  const HorizontalSliverList({
    required this.children,
    this.listPadding = const EdgeInsets.all(8),
    this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: listPadding,
          child: Row(children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1) addDivider(),
            ],
          ]),
        ),
      ),
    );
  }

  Widget addDivider() => divider ?? Padding(padding: const EdgeInsets.symmetric(horizontal: 8));
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const HeaderDelegate({
    required this.child,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
