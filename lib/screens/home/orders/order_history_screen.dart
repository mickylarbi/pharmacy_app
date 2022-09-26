import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/orders/order_details_screen.dart';
import 'package:pharmacy_app/screens/home/orders/orders_list_page.dart';
import 'package:pharmacy_app/utils/functions.dart';

class OrderHistoryScreen extends StatelessWidget {
  final List<Order> ordersList;
  const OrderHistoryScreen({Key? key, required this.ordersList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ordersList.isEmpty
          ? const Center(
              child: Text(
              'No orders to show',
              style: TextStyle(color: Colors.grey),
            ))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: ordersList.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: () {
                    navigate(
                        context,
                        OrderDetailsScreen(
                          order: ordersList[index],
                        ));
                  },
                  child: OrderCard(
                    order: ordersList[index],
                  )),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
            ),
    );
  }
}
