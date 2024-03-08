import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/features/order/data/model/order_model.dart';
import 'package:take_order_app/src/features/order/presentation/widget/order_item_view_by_status_widget.dart';

import '../../../core/helper/date_helper.dart';
import '../../order/presentation/provider/order_provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;
  final DateTime orderDate;

  const OrderDetailScreen({super.key, required this.orderId, required this.orderDate});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            FilledButton(
              style: ButtonStyle(
                padding: ButtonState.all(EdgeInsets.zero),
              ),
              child: Container(
                height: 40,
                width: 40,
                child: Icon(FluentIcons.back, size: 20),
              ),
              onPressed: () {
                context.go('/orders');
              },
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text('Order #${orderId}'),
              ),
            ),
            FilledButton(
              style: ButtonStyle(
                padding: ButtonState.all(EdgeInsets.zero),
              ),
              child: Container(
                height: 40,
                width: 40,
                child: Icon(FluentIcons.edit, size: 20),
              ),
              onPressed: () {
                context.go('/orders/${orderDate}/${orderId}/update');
              },
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
      content: FutureBuilder<OrderModel?>(
        future: context.read<OrderProvider>().getOrderDetail(orderId, orderDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ProgressRing(),
            );
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            print(snapshot.data);
            OrderModel orderModel = snapshot.data!;

            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                    padding: EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 20),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    FluentIcons.event_date,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text('${DateHelper.getFormattedDateWithoutTime(orderModel!.date)}'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    FluentIcons.clock,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text('${DateHelper.get24HourTime(orderModel!.time)}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    FluentIcons.contact,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text('${orderModel!.customer.fName} ${orderModel!.customer.lName}'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    FluentIcons.phone,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('${orderModel!.customer.countryCode}${orderModel!.customer.phoneNumber}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Icon(
                                    FluentIcons.circle_dollar,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: '${orderModel.paidAmount}', style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' / '),
                                  TextSpan(text: '${orderModel.totalAmount}'),
                                ])),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    // rounded rectanmgle
                                    shape: BoxShape.circle,
                                    color: orderModel.paidAmount == orderModel.totalAmount ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: StatusWidget(status: orderModel.status.name)),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Items', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Column(
                        children: List.generate(orderModel!.cart.length, (index) {
                          return Card(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                leading: Container(
                                  child: Image(
                                    errorBuilder: (context, error, stackTrace) {
                                      return SizedBox();
                                    },
                                    image: NetworkImage(orderModel!.cart[index].product.imageUrl),
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                title: Text('${orderModel!.cart[index].product.name}'),
                                subtitle: Text('${orderModel!.cart[index].product.price}'),
                                trailing: Text(orderModel!.cart[index].quantity.toString()),
                              ));
                        }),
                      ),
                    ],
                  )),
                  Card(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount'),
                          Text(orderModel.totalAmount.toString()),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No data found'),
            );
          }
        },
      ),
    );
  }
}
