import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/features/order/presentation/widget/date_item_widget.dart';
import 'package:take_order_app/src/features/order/presentation/widget/drawer_widget.dart';

import '../../data/model/order_model.dart';
import '../provider/order_provider.dart';
import '../widget/order_item_view_by_status_widget.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

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
        currentDate: context.read<OrderProvider>().selectedDate,
        initialDate: context.read<OrderProvider>().selectedDate,
        // first date of the year
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(
      drawer: DrawerWidget(
        orderDate: context.read<OrderProvider>().selectedDate,
      ),
      body: CustomScrollView(controller: _mainScrollController, slivers: [
        material.SliverAppBar(
          actions: [
            IconButton(
              onPressed: () async {
                DateTime now = DateTime.now();
                context.read<OrderProvider>().setSelectedDate(now);
              },
              icon: const Icon(FluentIcons.goto_today, size: 30),
            ),
            IconButton(
              onPressed: () async {
                await selectDate().then((value) {
                  if (value != null) {
                    context.read<OrderProvider>().setSelectedDate(value);
                  }
                });
              },
              icon: const Icon(FluentIcons.event_date, size: 30),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          collapsedHeight: 60,
          pinned: true,
          floating: true,
          expandedHeight: 140,
          backgroundColor: Colors.blue,
          centerTitle: false,
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(DateHelper.getMonthNameAndYear(context.watch<OrderProvider>().selectedDate!)),
          ]),
          flexibleSpace: material.FlexibleSpaceBar(
            background: Container(
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
/*
                      clipBehavior: Clip.none,
*/
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [
                            0.0,
                            0.9,
                            0.9,
                            1.0,
                          ],
                          colors: [
                            Colors.blue,
                            Colors.blue,
                            FluentTheme.of(context).inactiveBackgroundColor,
                            FluentTheme.of(context).inactiveBackgroundColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      width: double.infinity,
                      height: 80,
                      child: GridView(
                          controller: _testController,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 0,
                            mainAxisExtent: 80,
                          ),
                          children: [
                            for (DateTime dateItem in DateHelper.getDaysInWeek(context.read<OrderProvider>().selectedDate!))
                              DateItemWidget(
                                selectedDate: context.read<OrderProvider>().selectedDate!,
                                value: 'test',
                                dateItem: dateItem,
                              ),
                          ]),
                    ),
                  ],
                )),
          ),
        ),
        FutureBuilder(
          future: context.read<OrderProvider>().getOrdersByDate(context.read<OrderProvider>().selectedDate!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> lstHourMap = [];

                List<OrderModel> orderList = snapshot.data as List<OrderModel>;
                print('order list length');
                print(orderList.length);
                List<int> lstHour = List.generate(24, (index) => index);

                double sum = 0;
                for (var hour in lstHour) {
                  double height = 60;
                  List<OrderModel> orderListOfTheHour = orderList.where((element) => element.time.hour == hour).toList();
                  height = height + (orderListOfTheHour.length * height);
                  sum = sum + height;
                  Map<String, dynamic> map = {
                    'hour': hour,
                    'order': orderListOfTheHour,
                    'position': sum,
                  };
                  lstHourMap.add(map);
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      Map<String, dynamic> data = lstHourMap[index];
                      return Container(
                        color: FluentTheme.of(context).inactiveBackgroundColor,
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 60,
                              child: Text(
                                '${data['hour']} h',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  constraints: BoxConstraints(
                                    minHeight: 60,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: data['order'].isNotEmpty
                                      ? Expander(
                                          header: Text('${data['order'].length} orders'),
                                          content: Column(
                                            children: List.generate(
                                              data['order'].length,
                                              (index) => OrdersItemViewByStatus(
                                                status: data['order'][index].status.name,
                                                order: data['order'][index],
                                              ),
                                            ),
                                          ),
                                        )
                                      : null),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: lstHourMap.length,
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
