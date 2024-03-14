import 'package:fluent_ui/fluent_ui.dart';

class SuccessPage extends StatefulWidget {
  final Animation<double> animation;
  const SuccessPage({super.key, required this.animation});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // animated icon
          AnimatedBuilder(
            animation: widget.animation,
            child: Icon(
              FluentIcons.skype_circle_check,
              size: 200,
              color: Colors.green,
            ),
            builder: (context, child) {
              return Transform.scale(
                scale: widget.animation.value,
                child: child,
              );
            },
          ),
          Text(
            'Order has been placed successfully',
            style: TextStyle(fontSize: 16),
          ),
          Container(
            width: 300,
            height: 50,
            child: FilledButton(
              onPressed: () {
                /*context.go('/orders');*/
                Navigator.pop(context);
              },
              child: Text('Go to Orders'),
            ),
          ),
        ],
      ),
    );
  }
}
