import 'package:fluent_ui/fluent_ui.dart';

class OrderTrackDetailScreen extends StatefulWidget {
  final int orderId;
  const OrderTrackDetailScreen({super.key, required this.orderId});

  @override
  State<OrderTrackDetailScreen> createState() => _OrderTrackDetailScreenState();
}

class _OrderTrackDetailScreenState extends State<OrderTrackDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: Text('Order Track Detail Screen'),
      ),
    );
  }
}
