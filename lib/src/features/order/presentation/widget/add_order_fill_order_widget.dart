import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../../../core/helper/price_helper.dart';
import '../provider/order_provider.dart';

class FillOrderPage extends StatefulWidget {
  const FillOrderPage({super.key});

  @override
  State<FillOrderPage> createState() => _FillOrderPageState();
}

class _FillOrderPageState extends State<FillOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Container(
        child: context.watch<OrderProvider>().cartList.isNotEmpty
            ? Column(children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: context.watch<OrderProvider>().cartList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: Container(
                            child: Image(
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox();
                              },
                              image: NetworkImage(context.watch<OrderProvider>().cartList[index].product.imageUrl),
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text('${context.watch<OrderProvider>().cartList[index].product.name}'),
                          subtitle: Text('${context.watch<OrderProvider>().cartList[index].product.price}'),
                          trailing: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    int currentQty = context.read<OrderProvider>().cartList[index].quantity;
                                    if (currentQty > 1) {
                                      context.read<OrderProvider>().updateQuantityCartList(index, currentQty - 1);
                                    } else {
                                      context.read<OrderProvider>().removeCartList(context.read<OrderProvider>().cartList[index]);
                                    }
                                  },
                                  icon: Icon(FluentIcons.remove),
                                ),
                                Text(context.watch<OrderProvider>().cartList[index].quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    int currentQty = context.read<OrderProvider>().cartList[index].quantity;
                                    context.read<OrderProvider>().updateQuantityCartList(index, currentQty + 1);
                                  },
                                  icon: Icon(FluentIcons.add),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            // global key for form builder
                            final _formKeyQty = GlobalKey<FormState>();
                            int qty = context.read<OrderProvider>().cartList[index].quantity;

                            await showDialog<bool>(
                              context: context,
                              builder: (context) => ContentDialog(
                                constraints: BoxConstraints(maxWidth: 400, maxHeight: MediaQuery.of(context).size.height * 0.8),
                                title: Container(
                                  alignment: Alignment.center,
                                  child: const Text('Edit Quantity'),
                                ),
                                content: Column(
                                  children: [
                                    Form(
                                      key: _formKeyQty,
                                      child: NumberFormBox<int>(
                                        onChanged: (value) {
                                          setState(() {
                                            qty = value!;
                                          });
                                        },
                                        value: qty,
                                        placeholder: 'Quantity',
                                        min: 0,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        validator: FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                          FormBuilderValidators.integer(),
                                          FormBuilderValidators.min(1, errorText: 'Quantity must be greater than 0'),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Button(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FilledButton(
                                    child: const Text('Confirm'),
                                    onPressed: () {
                                      if (_formKeyQty.currentState!.validate()) {
                                        context.read<OrderProvider>().updateQuantityCartList(index, qty);
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
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
              ])
            : Center(
                child: Text(
                  'No item added\nPlease add item first',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
      ),
    );
  }
}
