import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

class OrderTrackDetailScreen extends StatefulWidget {
  final int orderId;
  final DateTime orderDate;
  const OrderTrackDetailScreen({super.key, required this.orderId, required this.orderDate});

  @override
  State<OrderTrackDetailScreen> createState() => _OrderTrackDetailScreenState();
}

class _OrderTrackDetailScreenState extends State<OrderTrackDetailScreen> {
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
                      'Order #${widget.orderId} - ${widget.orderDate}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
      content: Center(
        child: Text('Order Track Detail Screen'),
      ),
    );
  }
}
