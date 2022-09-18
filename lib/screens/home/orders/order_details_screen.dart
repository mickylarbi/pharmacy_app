import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/order.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.order.id!)),
      body: ListView(
        children: [],
      ),
    );
  }
}
