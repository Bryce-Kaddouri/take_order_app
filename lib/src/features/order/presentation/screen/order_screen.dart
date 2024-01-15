import 'dart:math';

import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DateTime? selectedDate;

  Random random = Random();

  @override
  void initState() {
    setState(() {
      selectedDate = DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: CalendarAppBar(
        fullCalendar: true,
        onDateChanged: (value) => setState(() => selectedDate = value),
        lastDate: DateTime.now(),
        events: List.generate(
            100,
            (index) => DateTime.now()
                .subtract(Duration(days: index * random.nextInt(5)))),
      ),*/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            collapsedHeight: 100,
            pinned: true,
            floating: true,
            expandedHeight: 200,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Calendar Appbar"),
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
