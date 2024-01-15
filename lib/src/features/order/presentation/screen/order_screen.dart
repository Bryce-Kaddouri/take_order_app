import 'dart:math';

import 'package:flutter/material.dart';
import 'package:calendar_appbar/calendar_appbar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  ScrollController _mainScrollController = ScrollController();
  ScrollController _horizontalScrollController = ScrollController();
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
        controller: _mainScrollController,
        slivers: [
          HorizontalSliverList(
            children: List.generate(
              100,
              (index) => Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: Text("Item $index"),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    child: Text('data'),
                  ),
                  Card(
                    child: Text('data'),
                  ),
                  Card(
                    child: Text('data'),
                  ),
                  Card(
                    child: Text('data'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 200,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100.0,
                    child: Card(
                      child: Text('data'),
                    ),
                  );
                },
              ),
            ),
          ),

          // horizontal list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                width: 100,
                height: 100,
                color: Colors.green,
                child: Text("Item $index"),
              ),
              childCount: 10,
            ),
          ),
          SliverAppBar(
            collapsedHeight: 100,
            pinned: true,
            floating: true,
            expandedHeight: 200,
            backgroundColor: Colors.blue,
            flexibleSpace: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: Colors.red,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                  child: Text("Item $index"),
                ),
              ),
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
