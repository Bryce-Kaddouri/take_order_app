import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../../../main.dart';
import '../../../../core/helper/date_helper.dart';

class SuccessPage extends StatefulWidget {
  final Animation<double> animation;
  final bool isUpdate;
  final int? orderId;
  final DateTime? orderDate;
  const SuccessPage(
      {super.key,
      required this.animation,
      this.isUpdate = false,
      this.orderId,
      this.orderDate});

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
            widget.isUpdate
                ? TranslationHelper(context: context)
                    .getTranslation('orderAdded')
                : TranslationHelper(context: context)
                    .getTranslation('orderAdded'),
            style: TextStyle(fontSize: 16),
          ),
          Container(
            width: 300,
            height: 50,
            child: FilledButton(
              onPressed: () {
                /*context.go('/orders');*/
                if (widget.isUpdate) {
                  String date = DateHelper.getFormattedDate(widget.orderDate!);
                  context.go('/orders/$date/${widget.orderId!}');
                } else {
                  context.go('/orders');
                }
              },
              child: Text(TranslationHelper(context: context)
                  .getTranslation('goToHome')),
            ),
          ),
        ],
      ),
    );
  }
}
