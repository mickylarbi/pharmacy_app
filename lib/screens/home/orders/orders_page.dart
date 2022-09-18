import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/orders/order_details_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 20,
      itemBuilder: (context, index) => OrderCard(
        order: Order(
            id: 'asldfjdsfj',
            dateTime: DateTime.now(),
            status: OrderStatus.canceled),
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            OrderDetails(
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
