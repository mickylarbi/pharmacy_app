import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/orders/orders_list_page.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_orders/pharmacy_order_details_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({Key? key}) : super(key: key);

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  ScrollController scrollController = ScrollController();

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Text(
            'Pending',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.myOrders
                  .where('status', isEqualTo: OrderStatus.pending.index)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Something went wrong'),
                        IconButton(
                            onPressed: () {
                              setState(
                                () {},
                              );
                            },
                            icon: const Icon(Icons.refresh))
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                ordersList = snapshot.data!.docs
                    .map((e) => Order.fromFirestore(e.data(), e.id))
                    .toList();

                return ordersList.isEmpty
                    ? const Center(
                        child: Text(
                          'No pending orders',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        clipBehavior: Clip.none,
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        itemCount: ordersList.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 20);
                        },
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                          onTap: () {
                            navigate(
                                context,
                                OrderDetailsScreen(
                                  order: ordersList[index],
                                ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(.2),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ordersList[index].id!),
                                    Text(
                                        '${DateFormat.yMMMMd().format(ordersList[index].dateTime!)} at ${DateFormat.jm().format(ordersList[index].dateTime!)}'),
                                  ],
                                ),
                                CircleAvatar(
                                  backgroundColor: orderStatusColor(
                                      ordersList[index].status!),
                                  radius: 14,
                                  child: Icon(
                                    orderStatusIconData(
                                        ordersList[index].status!),
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
              });
        }),
        const SizedBox(height: 100),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 36, 20, 24),
          child: Text(
            'Enroute',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: StatefulBuilder(builder: (context, setState) {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: db.myOrders
                    .where('status', isEqualTo: OrderStatus.enroute.index)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Something went wrong'),
                          IconButton(
                              onPressed: () {
                                setState(
                                  () {},
                                );
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  List<Order> ordersList = snapshot.data!.docs
                      .map((e) => Order.fromFirestore(e.data(), e.id))
                      .toList();
                  return ordersList.isEmpty
                      ? const Center(
                          child: Text(
                            'No orders enroute',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          itemCount: ordersList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 24);
                          },
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              navigate(
                                  context,
                                  OrderDetailsScreen(
                                    order: ordersList[index],
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(ordersList[index].id!),
                                      Text(
                                          '${DateFormat.yMMMMd().format(ordersList[index].dateTime!)} at ${DateFormat.jm().format(ordersList[index].dateTime!)}'),
                                    ],
                                  ),
                                  const SizedBox(width: 30),
                                  CircleAvatar(
                                    backgroundColor: orderStatusColor(
                                        ordersList[index].status!),
                                    radius: 14,
                                    child: Icon(
                                      orderStatusIconData(
                                          ordersList[index].status!),
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                });
          }),
        ),
      ],
    );
  }
}

Color orderStatusColor(OrderStatus orderStatus) {
  switch (orderStatus) {
    case OrderStatus.pending:
      return Colors.grey;
    case OrderStatus.enroute:
      return Colors.orange;
    case OrderStatus.delivered:
      return Colors.green;
    case OrderStatus.canceled:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData orderStatusIconData(OrderStatus orderStatus) {
  switch (orderStatus) {
    case OrderStatus.pending:
      return Icons.more_horiz;
    case OrderStatus.enroute:
      return Icons.delivery_dining_rounded;
    case OrderStatus.delivered:
      return Icons.done;
    case OrderStatus.canceled:
      return Icons.clear;
    default:
      return Icons.pending;
  }
}

String orderStatusMessage(OrderStatus orderStatus) {
  switch (orderStatus) {
    case OrderStatus.pending:
      return 'Order is pending delivery';
    case OrderStatus.enroute:
      return 'Order is enroute';
    case OrderStatus.delivered:
      return 'Order has been delivered';
    case OrderStatus.canceled:
      return 'Order has been canceled';
    default:
      return 'Order is pending';
  }
}
