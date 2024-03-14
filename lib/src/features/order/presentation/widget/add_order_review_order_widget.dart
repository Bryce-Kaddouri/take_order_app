import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/helper/date_helper.dart';
import '../../../../core/helper/price_helper.dart';
import '../../../customer/data/model/customer_model.dart';
import '../provider/order_provider.dart';

class ReviewOrderPage extends StatefulWidget {
  final DateTime selectedDate;
  final int selectedCustomerId;
  final List<CustomerModel> lstCustomers;

  const ReviewOrderPage({super.key, required this.selectedDate, required this.selectedCustomerId, required this.lstCustomers});

  @override
  State<ReviewOrderPage> createState() => _ReviewOrderPageState();
}

class _ReviewOrderPageState extends State<ReviewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
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
                child: Icon(FluentIcons.date_time),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text('${DateHelper.getFormattedDateTime(widget.selectedDate)}'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.selectedCustomerId != -1)
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
                        child: Icon(FluentIcons.contact),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text('${widget.lstCustomers.firstWhere((element) => element.id == widget.selectedCustomerId).fName} ${widget.lstCustomers.firstWhere((element) => element.id == widget.selectedCustomerId).lName}'),
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
                        child: Icon(FluentIcons.phone),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('${widget.lstCustomers.firstWhere((element) => element.id == widget.selectedCustomerId).countryCode}${widget.lstCustomers.firstWhere((element) => element.id == widget.selectedCustomerId).phoneNumber}'),
                    ],
                  ),
                ),
              ],
            ),
          SizedBox(
            height: 10,
          ),
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
                    trailing: Text(context.watch<OrderProvider>().cartList[index].quantity.toString()),
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
        ],
      ),
    );
  }
}
