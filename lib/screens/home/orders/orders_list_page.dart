import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/orders/order_details_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.myOrders.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Icon(Icons.error_rounded));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          ordersList = snapshot.data!.docs
              .map((e) => Order.fromFirestore(e.data(), e.id))
              .toList();

          ordersList.sort(
            (a, b) => '${a.dateTime}${a.status}'
                .compareTo('${b.dateTime}${b.status}'),
          );

          List<Order> currentOrdersList = ordersList
              .where((element) =>
                  element.status == OrderStatus.pending ||
                  element.status == OrderStatus.enroute)
              .toList();

          return ordersList.isEmpty
              ? const Center(
                  child: Text(
                  'No orders to show',
                  style: TextStyle(color: Colors.grey),
                ))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: currentOrdersList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                          onTap: () {
                            navigate(
                                context,
                                OrderDetailsScreen(
                                  order: currentOrdersList[index],
                                ));
                          },
                          child: OrderCard(
                            order: currentOrdersList[index],
                          )),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                );
        });
  }
}

List<Order> ordersList = [];

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            OrderDetailsScreen(
              order: order,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.id!),
            const SizedBox(height: 5),
            Text(
                '${DateFormat.yMMMd().format(order.dateTime!)} at ${DateFormat.jm().format(order.dateTime!)}'),
            const SizedBox(height: 10),
            Text(
              orderStatusString(order.status!),
              style: TextStyle(color: orderStatusColor(order.status!)),
            ),
          ],
        ),
      ),
    );
  }
}

Color orderStatusColor(OrderStatus orderStatus) {
  switch (orderStatus) {
    case OrderStatus.pending:
      return Colors.grey;
    case OrderStatus.enroute:
      return Colors.yellow;
    case OrderStatus.delivered:
      return Colors.green;
    case OrderStatus.canceled:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String orderStatusString(OrderStatus orderStatus) {
  switch (orderStatus) {
    case OrderStatus.pending:
      return 'Pending...';
    case OrderStatus.enroute:
      return 'On the way';
    case OrderStatus.delivered:
      return 'Delivered';
    case OrderStatus.canceled:
      return 'Canceled';
    default:
      return '...';
  }
}
