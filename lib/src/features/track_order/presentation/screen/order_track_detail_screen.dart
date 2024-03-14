import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
import 'package:take_order_app/src/core/helper/price_helper.dart';
import 'package:take_order_app/src/features/order/business/param/get_order_by_id_param.dart';
import 'package:take_order_app/src/features/order/presentation/provider/order_provider.dart';

import '../../../../core/constant/app_color.dart';
import '../../../../core/helper/responsive_helper.dart';
import '../../../order/data/model/order_model.dart';
import '../../../order/presentation/widget/order_item_view_by_status_widget.dart';

class OrderTrackDetailScreen extends StatefulWidget {
  final int orderId;
  final DateTime orderDate;
  const OrderTrackDetailScreen({super.key, required this.orderId, required this.orderDate});

  @override
  State<OrderTrackDetailScreen> createState() => _OrderTrackDetailScreenState();
}

class _OrderTrackDetailScreenState extends State<OrderTrackDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return material.Scaffold(

        /*header: Container(
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
              Container(
                height: 60,
                width: 44,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: FilledButton(
                  style: ButtonStyle(
                    padding: ButtonState.all(EdgeInsets.all(0)),
                  ),
                  onPressed: () {
                    context.go('/track-order/${DateHelper.getFormattedDate(widget.orderDate)}');
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Icon(FluentIcons.back),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: 60,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FluentIcons.streaming, size: 24),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${DateHelper.getFormattedDate(widget.orderDate)} - #${widget.orderId}',
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
        ),*/
        backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
        appBar: material.AppBar(
          leading: material.BackButton(
            onPressed: () async {
              context.go('/track-order/${DateHelper.getFormattedDate(widget.orderDate)}');
            },
          ),
          centerTitle: true,
          shadowColor: FluentTheme.of(context).shadowColor,
          surfaceTintColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
          backgroundColor: FluentTheme.of(context).navigationPaneTheme.backgroundColor,
          elevation: 4,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FluentIcons.streaming, size: 24),
              SizedBox(
                width: 8,
              ),
              Text(
                '${DateHelper.getFormattedDate(widget.orderDate)} - #${widget.orderId}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10),
          child: FutureBuilder(
            future: context.read<OrderProvider>().getOrderDetail(widget.orderId, widget.orderDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ProgressRing(),
                );
              } else {
                OrderModel order = snapshot.data as OrderModel;
                print(order.status.step);
                print(order.createdAt);
                print(order.cookingAt);
                print(order.readyAt);
                print(order.collectedAt);

                if (ResponsiveHelper.isMobile(context)) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomerHourWidget(
                                order: order,
                              ),
                              ProductsItemListView(
                                order: order,
                              ),
                              StatusWithButtonWidget(
                                order: order,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (order.status.step == 3)
                        Card(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            height: 50,
                            child: StatusButton(
                              order: order,
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: ProductsItemListView(
                          order: order,
                        ),
                      ),
                      Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          CustomerHourWidget(
                            order: order,
                          ),
                          Spacer(),
                          StatusWithButtonWidget(
                            order: order,
                          ),
                        ]),
                      ),
                    ],
                  );
                }
              }
            },
          ),
        ));
  }
}

class StatusStepWidget extends StatefulWidget {
  OrderModel order;
  StatusStepWidget({super.key, required this.order});

  @override
  State<StatusStepWidget> createState() => _StatusStepWidgetState();
}

class _StatusStepWidgetState extends State<StatusStepWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                      child: Row(
                    children: [
                      if (widget.order.status.step > 1)
                        Container(
                          height: 40,
                          width: 40,
                          child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                        )
                      else
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: AppColor.pendingForegroundColor,
                            child: Text(
                              '1', /*style: FluentTheme.of(context)..bodyLarge!.copyWith(fontSize: 20, color: widget.order.status.step >= 1 ? Theme.of(context).colorScheme.secondary : AppColor.lightGreyTextColor)*/
                            ),
                          ),
                        ),
                      SizedBox(width: 10),
                      StatusWidget(
                        status: 'Pending',
                      ),
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: // return 90 deg a divider
                              Container(
                            width: 2,
                            height: 30,
                            color: widget.order.status.step > 1 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${DateHelper.getFormattedDateTime(widget.order.createdAt)}',
                          /* style: */ /*AppTextStyle.lightTextStyle(fontSize: 16),*/ /*
                                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16)*/
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      child: Row(
                    children: [
                      if (widget.order.status.step > 2)
                        Container(
                          height: 40,
                          width: 40,
                          child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                        )
                      else
                        Container(
                          height: 40,
                          width: 40,
                          child: CircleAvatar(
                            backgroundColor: widget.order.status.step >= 2 ? AppColor.cookingForegroundColor : AppColor.lightCardColor,
                            child: Text(
                              '2',
                              /*style: AppTextStyle.boldTextStyle(fontSize: 20, color: widget.order.status.step >= 2 ? Theme.of(context).primaryColor : AppColor.lightGreyTextColor),*/
                            ),
                          ),
                        ),
                      SizedBox(width: 10),
                      StatusWidget(
                        status: 'Cooking',
                      ),
                    ],
                  )),
                  if (widget.order.status.step >= 2)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 40,
                            height: 40,
                            child: // return 90 deg a divider
                                Container(
                              width: 2,
                              height: 30,
                              color: widget.order.status.step > 2 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${widget.order.cookingAt != null ? DateHelper.getFormattedDateTime(widget.order.cookingAt!) : ''}',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (widget.order.status.step >= 2)
              Container(
                child: Column(
                  children: [
                    Container(
                        child: Row(
                      children: [
                        if (widget.order.status.step >= 3)
                          Container(
                            height: 40,
                            width: 40,
                            child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                          )
                        else
                          Container(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: widget.order.status.step >= 3 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                              child: Text(
                                '3',
                              ),
                            ),
                          ),
                        SizedBox(width: 10),
                        StatusWidget(
                          status: 'Completed',
                        ),
                      ],
                    )),
                    if (widget.order.status.step >= 3)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                            ),
                            SizedBox(width: 10),
                            Text('${DateHelper.getFormattedDateTime(widget.order.readyAt!)}' /*AppTextStyle.lightTextStyle(fontSize: 16)*/),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            if (widget.order.status.step >= 3)
              Container(
                child: Column(
                  children: [
                    Container(
                        child: Row(
                      children: [
                        if (widget.order.status.step >= 4)
                          Container(
                            height: 40,
                            width: 40,
                            child: Icon(FluentIcons.check_mark, color: AppColor.completedForegroundColor, size: 40),
                          )
                        else
                          Container(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: widget.order.status.step >= 4 ? AppColor.completedForegroundColor : AppColor.lightCardColor,
                              child: Text(
                                '3',
                              ),
                            ),
                          ),
                        SizedBox(width: 10),
                        StatusWidget(
                          status: 'Collected',
                        ),
                      ],
                    )),
                    if (widget.order.status.step >= 4)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                            ),
                            SizedBox(width: 10),
                            Text('${DateHelper.getFormattedDateTime(widget.order.collectedAt!)}' /*AppTextStyle.lightTextStyle(fontSize: 16)*/),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      )),
      if ((widget.order.status.step == 3) && !ResponsiveHelper.isMobile(context))
        StatusButton(
          order: widget.order,
        ),
    ]);
  }
}

class StatusButton extends StatefulWidget {
  OrderModel order;
  StatusButton({super.key, required this.order});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Container(
        height: 30,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text('Collected'),
      ),
      onPressed: () {
        GetOrderByIdParam param = GetOrderByIdParam(orderId: widget.order.id!, date: widget.order.createdAt);
        context.read<OrderProvider>().updateToCollectedOrder(param).then((value) async {
          if (value) {
            await displayInfoBar(
              context,
              builder: (context, close) {
                return InfoBar(
                  title: const Text('Order Collected'),
                  content: const Text('The order has been successfully collected by the customer.'),
                  action: IconButton(
                    icon: const Icon(FluentIcons.clear),
                    onPressed: close,
                  ),
                  severity: InfoBarSeverity.success,
                );
              },
              alignment: Alignment.topRight,
            );
            context.go('/track-order/${DateHelper.getFormattedDate(widget.order.createdAt)}');
          }
        });
      },
    );
  }
}

class ProductsItemListView extends StatelessWidget {
  OrderModel order;
  ProductsItemListView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    int nbItems = order.cart.fold(0, (previousValue, element) => previousValue + element.quantity);
    return ResponsiveHelper.isMobile(context)
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Expander(
                initiallyExpanded: true,
                header: Text(
                  '${nbItems} items',
                ),
                content: Column(
                  children: List.generate(order.cart.length, (index) {
                    return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Container(
                            child: Image(
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox();
                              },
                              image: NetworkImage(order!.cart[index].product.imageUrl),
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text('${order!.cart[index].product.name}'),
                          subtitle: Text('${order!.cart[index].product.price}'),
                          trailing: Text(order!.cart[index].quantity.toString()),
                        ));
                  }),
                )))
        : Card(
            margin: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20) : EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
                height: !ResponsiveHelper.isMobile(context) ? MediaQuery.of(context).size.height : null,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).scaffoldBackgroundColor,
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '${nbItems} items',
                      ),
                    ),
                    if (!ResponsiveHelper.isMobile(context))
                      Expanded(
                        child: Container(
                          color: FluentTheme.of(context).menuColor,
                          child: ListView.builder(
                            padding: EdgeInsets.all(10),
                            shrinkWrap: true,
                            itemCount: order!.cart.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    leading: Container(
                                      child: Image(
                                        errorBuilder: (context, error, stackTrace) {
                                          return SizedBox();
                                        },
                                        image: NetworkImage(order!.cart[index].product.imageUrl),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    title: Text('${order!.cart[index].product.name}'),
                                    subtitle: Text('${PriceHelper.getFormattedPrice(order!.cart[index].product.price)}'),
                                    trailing: Text(order!.cart[index].quantity.toString()),
                                  ));
                            },
                          ),
                        ),
                      )
                    else
                      Column(
                        children: List.generate(order.cart.length, (index) {
                          return Card(
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                leading: Container(
                                  child: Image(
                                    errorBuilder: (context, error, stackTrace) {
                                      return SizedBox();
                                    },
                                    image: NetworkImage(order!.cart[index].product.imageUrl),
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                title: Text('${order!.cart[index].product.name}'),
                                subtitle: Text('${order!.cart[index].product.price}'),
                                trailing: Text(order!.cart[index].quantity.toString()),
                              ));
                        }),
                      )
                  ],
                )));
  }
}

class CustomerHourWidget extends StatelessWidget {
  OrderModel order;
  CustomerHourWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: !ResponsiveHelper.isMobile(context)
          ? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20)
          : const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
      /*decoration: BoxDecoration(
        color: FluentTheme.of(context).menuColor,
        borderRadius: BorderRadius.circular(16),
      ),*/
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: const Icon(FluentIcons.contact, size: 32),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          child: Text(
                            '${order!.customer.lName} ${order!.customer.fName}',
                            style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 20),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 60,
                        child: Icon(FluentIcons.clock, size: 32),
                      ),
                      Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: Text(
                          DateHelper.get24HourTime(order.time),
                          style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontSize: 24),
                          /* style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),*/
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: Icon(
                                FluentIcons.circle_dollar,
                                size: 32,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(text: '${PriceHelper.getFormattedPrice(order.paidAmount)}', style: TextStyle(fontWeight: FontWeight.bold, color: FluentTheme.of(context).typography.subtitle!.color)),
                                      TextSpan(text: ' / ', style: TextStyle(color: FluentTheme.of(context).typography.subtitle!.color)),
                                      TextSpan(text: '${PriceHelper.getFormattedPrice(order.totalAmount)}', style: TextStyle(color: FluentTheme.of(context).typography.subtitle!.color)),
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
                                        color: order.paidAmount == order.totalAmount ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: /*Text(
                                          '(${orderModel.paidAmount == orderModel.totalAmount ? 'Paid' : 'Unpaid: ${orderModel.totalAmount - orderModel.paidAmount} left'})'),*/
                                      RichText(
                                          text: TextSpan(children: [
                                    if (order.paidAmount != order.totalAmount) TextSpan(text: '(${PriceHelper.getFormattedPrice(order.totalAmount - order.paidAmount)}', style: TextStyle(fontWeight: FontWeight.bold, color: FluentTheme.of(context).typography.subtitle!.color)),
                                    TextSpan(text: ' left)', style: TextStyle(color: FluentTheme.of(context).typography.subtitle!.color)),
                                  ])),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(right: 20, bottom: 5),
                  height: 40,
                  child: StatusWidget(
                    status: order.status.name,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class StatusWithButtonWidget extends StatelessWidget {
  OrderModel order;
  StatusWithButtonWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20) : const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20) : EdgeInsets.only(left: 10, right: 10, bottom: 20),
          constraints: BoxConstraints(
            maxHeight: order.status.step * 100 + 120,
          ),
          child: StatusStepWidget(
            order: order,
          ),
        ));
  }
}
