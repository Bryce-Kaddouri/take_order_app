import 'dart:math';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController _mainScrollController = ScrollController();
  ScrollController _horizontalScrollController = ScrollController();
  DateTime selectedDate = DateTime.now();

  Random random = Random();

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
    });
  }

  Future<DateTime?> selectDate() async {
    // global key for the form
    return showDatePicker(
        context: context,
        currentDate: selectedDate,
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
      body: CustomScrollView(
        controller: _mainScrollController,
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  DateTime? date = await selectDate();
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                    int currentDay = selectedDate.day;
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
            title: Text(DateHelper.getMonthNameAndYear(selectedDate!)),
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
                              DateTime newDate =
                                  DateTime(selectedDate!.year, 1, 1)
                                      .add(Duration(days: currentItem));

                              // check if the month is different from the current month
                              if (newDate.month != selectedDate!.month) {
                                setState(() {
                                  selectedDate = newDate;
                                });
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
                                  selectedDate,
                                  DateHelper.getDayInLetter(
                                      DateTime(selectedDate!.year, 1, 1)
                                          .add(Duration(days: index))),
                                  index),
                              childCount: DateHelper.getNbDaysInYear(
                                  selectedDate!.year),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ListTile(
                title: Text("Item $index"),
              ),
              childCount: 100,
            ),
          ),
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
