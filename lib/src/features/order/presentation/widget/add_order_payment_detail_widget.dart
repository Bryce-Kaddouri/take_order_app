import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../core/helper/price_helper.dart';
import '../provider/order_provider.dart';

class PaymentDetailPage extends StatefulWidget {
  final GlobalKey<FormState> fromKeyPayment;
  final double paymentAmount;
  final Function(double) onChangedPaidAmount;
  final TextEditingController noteController;

  const PaymentDetailPage(
      {super.key,
      required this.fromKeyPayment,
      this.paymentAmount = 0.0,
      required this.onChangedPaidAmount,
      required this.noteController});

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
              label: TranslationHelper(context: context)
                  .getTranslation('paymentAmount'),
              child: NumberFormBox<double>(
                autovalidateMode: AutovalidateMode.always,
                onChanged: (value) {
                  widget.onChangedPaidAmount(value!);
                  /*setState(() {
                    _paymentAmount = value!;
                  });*/
                },
                initialValue: widget.paymentAmount.toString(),
                value: widget.paymentAmount,
                placeholder: TranslationHelper(context: context)
                    .getTranslation('paymentAmount'),
                min: 0,
                max: context.watch<OrderProvider>().totalAmount,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0,
                      errorText: 'Payment amount must be greater than 0'),
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
                    label:
                        '${TranslationHelper(context: context).getTranslation('note')}:',
                    child: TextFormBox(
                      onChanged: (value) {
                        setState(() {});
                      },
                      maxLength: 200,
                      controller: widget.noteController,
                      placeholder:
                          '${TranslationHelper(context: context).getTranslation('note')} ...',
                      minLines: 3,
                      maxLines: 6,
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text: widget.noteController.text.length.toString(),
                        style: TextStyle(
                          color: widget.noteController.text.length > 200
                              ? Colors.red
                              : Colors.black,
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
                  Text(TranslationHelper(context: context)
                      .getTranslation('totalAmount')),
                  Text(PriceHelper.getFormattedPrice(
                      context.watch<OrderProvider>().totalAmount)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
