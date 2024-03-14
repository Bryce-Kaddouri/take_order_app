import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../../../core/helper/price_helper.dart';
import '../provider/order_provider.dart';

class PaymentDetailPage extends StatefulWidget {
  final GlobalKey<FormState> fromKeyPayment;
  final double paymentAmount;
  final Function(double) onChangedPaidAmount;
  final TextEditingController noteController;

  const PaymentDetailPage({super.key, required this.fromKeyPayment, required this.paymentAmount, required this.onChangedPaidAmount, required this.noteController});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: widget.fromKeyPayment,
        child: Column(
          children: [
            InfoLabel(
              label: 'Payment Amount:',
              child: NumberFormBox<double>(
                onChanged: (value) {
                  widget.onChangedPaidAmount(value!);
                  /*setState(() {
                    _paymentAmount = value!;
                  });*/
                },
                value: widget.paymentAmount,
                placeholder: 'Payment Amount',
                min: 0,
                max: context.watch<OrderProvider>().totalAmount,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0, errorText: 'Payment amount must be greater than 0'),
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  InfoLabel(
                    label: 'Note:',
                    child: TextFormBox(
                      onChanged: (value) {
                        setState(() {});
                      },
                      maxLength: 200,
                      controller: widget.noteController,
                      placeholder: 'Note ...',
                      minLines: 3,
                      maxLines: 6,
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text: widget.noteController.text.length.toString(),
                        style: TextStyle(
                          color: widget.noteController.text.length > 200 ? Colors.red : Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '/200',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount'),
                  Text(PriceHelper.getFormattedPrice(context.watch<OrderProvider>().totalAmount)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
