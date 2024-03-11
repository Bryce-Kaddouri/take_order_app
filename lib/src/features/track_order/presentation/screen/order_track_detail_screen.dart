import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:take_order_app/src/core/helper/date_helper.dart';
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
                        'Order #${widget.orderId} - ${DateHelper.getFormattedDate(widget.orderDate)}',
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
        content: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: context.read<OrderProvider>().getOrderDetail(widget.orderId, widget.orderDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ProgressRing(),
                );
              } else {
                OrderModel order = snapshot.data as OrderModel;
                return Row(
                  children: [
                    Expanded(
                      child: ProductsItemListView(
                        order: order!,
                      ),
                    ),
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        CustomerHourWidget(
                          order: order!,
                        ),
                        Spacer(),
                        StatusWithButtonWidget(
                          order: order!,
                        ),
                      ]),
                    ),
                  ],
                );
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
          ],
        ),
      )),
      if ((widget.order.status.step == 1 || widget.order.status.step == 2) && !ResponsiveHelper.isMobile(context))
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
    return FilledButton(child: Text('Collected'), onPressed: () {});
  }
}

class ProductsItemListView extends StatelessWidget {
  OrderModel order;
  ProductsItemListView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    int nbItems = order.cart.fold(0, (previousValue, element) => previousValue + element.quantity);
    return Container(
        margin: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20) : EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        height: !ResponsiveHelper.isMobile(context) ? MediaQuery.of(context).size.height : null,
        decoration: BoxDecoration(
          color: FluentTheme.of(context).menuColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
/*
                    color: Theme.of(context).colorScheme.secondary,
*/
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                '${nbItems} items', /*style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20)*/ /*AppTextStyle.boldTextStyle(fontSize: 20)*/
              ),
            ),
            if (!ResponsiveHelper.isMobile(context))
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: order!.cart.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(children: [
                              Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Image.network(
                                        order!.cart[index].product.imageUrl ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(FluentIcons.eat_drink, size: 40),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${order!.cart[index].quantity}',
                                          /*style: */ /*AppTextStyle.boldTextStyle(
                                            fontSize: 24),*/ /*
                                          Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(fontSize: 24),*/
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'x',
                                      /*style: */ /*AppTextStyle.lightTextStyle(
                                          fontSize: 14)*/ /*
                                      Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 14),*/
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${order!.cart[index].product.name}',
                                  /*style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontSize: 20)*/
                                ),
                              ),
                              /*  AppTextStyle.boldTextStyle(fontSize: 16)),*/
                            ]),
                          ),
                          Divider()
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              Column(
                children: List.generate(order.cart.length, (index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(children: [
                            Container(
                              width: 100,
                              child: Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.network(
                                      order!.cart[index].product.imageUrl ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(FluentIcons.eat_drink, size: 40),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${order!.cart[index].quantity}',
                                        /* style: */ /*AppTextStyle.boldTextStyle(
                                            fontSize: 24),*/ /*
                                        Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(fontSize: 24),*/
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'x',
                                    /*  style: */ /*AppTextStyle.lightTextStyle(
                                          fontSize: 14)*/ /*
                                    Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 14),*/
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${order!.cart[index].product.name}',
                                /* style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontSize: 20)*/
                              ),
                            ),
                            /*  AppTextStyle.boldTextStyle(fontSize: 16)),*/
                          ]),
                        ),
                        Divider()
                      ],
                    ),
                  );
                }),
              )
          ],
        ));
  }
}

class CustomerHourWidget extends StatelessWidget {
  OrderModel order;
  CustomerHourWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: !ResponsiveHelper.isMobile(context)
          ? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20)
          : const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(FluentIcons.contact, size: 50),
                Expanded(
                  child: Container(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'Customer',
                        /* style: */ /*AppTextStyle.lightTextStyle(fontSize: 12)*/ /*
                            Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),*/
                      ),
                      Container(
                        child: Text(
                          '${order!.customer.lName} ${order!.customer.fName}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
/*
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),
*/
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(FluentIcons.clock, size: 50),
                Container(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'Hour',
                      /*style: */ /*AppTextStyle.lightTextStyle(fontSize: 12)),*/ /*
                            Theme.of(context).textTheme.bodySmall*/
                    ),
                    Text(
                      '${order!.time.hour < 10 ? '0${order!.time.hour}' : order!.time.hour} : ${order!.time.minute < 10 ? '0${order!.time.minute}' : order!.time.minute}',
                      /* style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20),*/
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class StatusWithButtonWidget extends StatelessWidget {
  OrderModel order;
  StatusWithButtonWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: !ResponsiveHelper.isMobile(context) ? const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20) : EdgeInsets.only(left: 10, right: 10, bottom: 20),
      constraints: BoxConstraints(
        maxHeight: order.status.step * 90 + 90,
      ),
      decoration: BoxDecoration(
/*
        color: Theme.of(context).cardColor,
*/
        borderRadius: BorderRadius.circular(16),
      ),
      child: StatusStepWidget(
        order: order!,
      ),
    );
  }
}
