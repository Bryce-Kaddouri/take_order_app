import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';

import '../../data/model/order_model.dart';
import '../provider/order_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController _mainScrollController = ScrollController();
  ScrollController _horizontalScrollController = ScrollController();
/*
  DateTime selectedDate = DateTime.now().subtract(Duration(days: 1));
*/
  List datas = [];

  Random random = Random();
  List<double> testRangeHours = [];
  int currentHour = 0;

  void initData(DateTime date) async {
    List<OrderModel> orderList =
        await context.read<OrderProvider>().getOrdersByDate(date);
    List<int> lstHour = List.generate(24, (index) => index);
    List<OrderModel> orderListOfTheDay = [];
    List<double> lstPosition = [];

    DateTime selectedDate = context.read<OrderProvider>().selectedDate;

    orderListOfTheDay = orderList
        .where((element) =>
            element.date.day == selectedDate.day &&
            element.date.month == selectedDate.month &&
            element.date.year == selectedDate.year)
        .toList();

    List<Map<String, dynamic>> lstHourMap = [];
    double sum = 0;
    for (var hour in lstHour) {
      double height = 60;
      List<OrderModel> orderListOfTheHour = orderListOfTheDay
          .where((element) => element.time.hour == hour)
          .toList();
      height = height + (orderListOfTheHour.length * height);
      sum = sum + height;
      Map<String, dynamic> map = {
        'hour': hour,
        'order': orderListOfTheHour,
        'position': sum,
      };
      lstHourMap.add(map);
    }
    print(lstHourMap);

    print(lstPosition);
    setState(() {
      datas = lstHourMap;
      testRangeHours = lstPosition;
    });

    print(orderListOfTheDay);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      int currentDay = DateTime.now().day;
      double width = MediaQuery.of(context).size.width;
      double itemWidth = width / 7;
      double w = itemWidth;
      print("w $w");
      _horizontalScrollController.animateTo(
        (currentDay - 1) * w,
        duration: Duration(milliseconds: 500),
        // bounce effect
        curve: Curves.easeOut,
      );
      List<OrderModel> orderListOfTheDay = [];

      print('lstHour');

      initData(context.read<OrderProvider>().selectedDate!);
    });
  }

  Future<DateTime?> selectDate() async {
    // global key for the form
    return showDatePicker(
        context: context,
        currentDate: context.read<OrderProvider>().selectedDate,
        initialDate: DateTime.now(),
        // first date of the year
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365)));
  }

  Widget test(DateTime date) {
    List<Widget> list = [];
    List.generate(7, (index) {
      DateTime newDate = date.add(Duration(days: index));
      print("newDate $newDate");
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 60,
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                newDate.day.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                DateHelper.getDayInLetter(newDate),
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    });

    return Row(
      children: list,
    );
  }

  Widget itemList(DateTime selectedDate, String value, int index) {
    double width = MediaQuery.of(context).size.width;
    double itemWidth = width / 7;
    print("itemWidth $itemWidth");
    int dayOfYear = index + 1;
    DateTime dateOfItem =
        DateTime(selectedDate.year, 1, 1).add(Duration(days: dayOfYear - 1));
    bool isToday = dateOfItem.day == selectedDate.day &&
        dateOfItem.month == selectedDate.month &&
        dateOfItem.year == selectedDate.year;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: isToday ? 5 : 0,
      color: isToday ? Colors.white : Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        width: itemWidth,
        height: isToday ? 70 : 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isToday)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            Text(
              dateOfItem.day.toString(),
              style: TextStyle(
                color: isToday ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              DateHelper.getDayInLetter(dateOfItem),
              style: TextStyle(
                  color: isToday ? Colors.black : Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Drawer Header"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.list_alt_outlined),
              title: Text("Order List"),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart_outlined),
              title: Text("Add Order"),
              onTap: () {
                context.go('/add-order');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text("Customer List"),
              onTap: () {
                context.go('/customers');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add_outlined),
              title: Text("Add Customer"),
              onTap: () {
                context.go('/customers/add');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text("Settings"),
              onTap: () {
                print('setting');
                context.go('/setting');
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        controller: _mainScrollController,
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  DateTime? date = await selectDate();
                  if (date != null) {
                    /*setState(() {
                        selectedDate = date;
                      });*/
                    context.read<OrderProvider>().setSelectedDate(date);
                    int currentDay =
                        context.read<OrderProvider>().selectedDate.day;
                    double width = MediaQuery.of(context).size.width;
                    double itemWidth = width / 7;
                    double w = itemWidth;
                    print("w $w");
                    _horizontalScrollController.animateTo(
                      (currentDay - 1) * w,
                      duration: Duration(milliseconds: 500),
                      // bounce effect
                      curve: Curves.easeOut,
                    );
                  }
                },
                icon: Icon(Icons.calendar_today),
              ),
            ],
            collapsedHeight: 60,
            pinned: true,
            floating: true,
            expandedHeight: 140,
            backgroundColor: Colors.blue,
            centerTitle: false,
            title: Text(DateHelper.getMonthNameAndYear(
                context.watch<OrderProvider>().selectedDate!)),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  color: Colors.blue,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        clipBehavior: Clip.none,
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
                              Colors.white,
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        width: double.infinity,
                        height: 80,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollNotification) {
                              // get the item of the width
                              double itemWidth =
                                  MediaQuery.of(context).size.width / 7;
                              // get the current scroll position
                              double scrollPos = notification.metrics.pixels;
                              // get the current item
                              int currentItem = (scrollPos / itemWidth).round();
                              print("currentItem $currentItem");
                              // get the month of the current item
                              DateTime newDate = DateTime(
                                      context
                                          .read<OrderProvider>()
                                          .selectedDate!
                                          .year,
                                      1,
                                      1)
                                  .add(Duration(days: currentItem));

                              // check if the month is different from the current month
                              if (newDate.month !=
                                  context
                                      .read<OrderProvider>()
                                      .selectedDate!
                                      .month) {
                                context
                                    .read<OrderProvider>()
                                    .setSelectedDate(newDate);
                              }
                            }
                            return true;
                          },

                          // 7 item in a row
                          child: ListView.custom(
                            controller: _horizontalScrollController,
                            itemExtent: MediaQuery.of(context).size.width / 7,
                            scrollDirection: Axis.horizontal,
                            childrenDelegate: SliverChildBuilderDelegate(
                              (context, index) => itemList(
                                  context.watch<OrderProvider>().selectedDate,
                                  DateHelper.getDayInLetter(DateTime(
                                          context
                                              .watch<OrderProvider>()
                                              .selectedDate!
                                              .year,
                                          1,
                                          1)
                                      .add(Duration(days: index))),
                                  index),
                              childCount: DateHelper.getNbDaysInYear(context
                                  .watch<OrderProvider>()
                                  .selectedDate!
                                  .year),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),

          /*if (datas.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                child: Text("No order"),
              ),
            )
          else
            SliverList.list(
              children: List.generate(datas.length, (index) {
                Map<String, dynamic> data = datas[index];
                return Row(
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
                        constraints: BoxConstraints(
                          minHeight: 60,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          children: List.generate(
                            data['order'].length,
                            (index2) {
                              OrderModel orderModel = data['order'][index2];
                              return Card(
                                color: Colors.red,
                                child: Container(
                                  height: 80,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(
                                          '${orderModel.time.format(context)}'),
                                      Text(
                                          '${orderModel.customer!.fName} ${orderModel.customer!.lName}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),*/
        ],
      ),
    );
  }
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

  Widget addDivider() =>
      divider ?? Padding(padding: const EdgeInsets.symmetric(horizontal: 8));
}
