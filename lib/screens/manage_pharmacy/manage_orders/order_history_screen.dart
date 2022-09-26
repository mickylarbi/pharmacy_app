import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/orders/orders_list_page.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_orders/orders_list_page.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_orders/pharmacy_order_details_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);

  FirestoreService db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.myOrders.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Icon(Icons.error_rounded));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            List<Order> ordersList = snapshot.data!.docs
                .map((e) => Order.fromFirestore(e.data(), e.id))
                .where((element) =>
                    element.status == OrderStatus.canceled ||
                    element.status == OrderStatus.delivered)
                .toList();

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(36, 100, 36, 50),
              itemCount: ordersList.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: () {
                    navigate(
                        context,
                        OrderDetailsScreen(
                          order: ordersList[index],
                        ));
                  },
                  child: OrderCard(order: ordersList[index])),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 20),
            );
          }),
    );
  }
}
