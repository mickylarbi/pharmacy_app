import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/drugs/drug_details_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_screen.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';
import 'package:pharmacy_app/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    FirestoreService db = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text(order.id!)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        children: [
          const SizedBox(height: 100),
          const Text(
            'Date ordered:',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            '${DateFormat.yMMMMd().format(order.dateTime!)} at ${DateFormat.jm().format(order.dateTime!)}',
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              MapEntry<String, int> entry = order.cart!.entries
                  .map((e) => MapEntry<String, int>(e.key, e.value.toInt()))
                  .toList()[index];

              return StatefulBuilder(builder: (context, setState) {
                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: db.drugDocument(entry.key).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                setState(() {});
                              }));
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Drug drug = Drug.fromFirestore(
                          snapshot.data!.data()!, snapshot.data!.id);

                      return GestureDetector(
                        onTap: () {
                          navigate(context, DrugDetailsScreen(drug: drug));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              DrugImageWidget(
                                drugId: drug.id!,
                                height: 70,
                                width: 70,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      drug.brandName!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      drug.genericName!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      drug.group!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'GH¢ ${drug.price!.toStringAsFixed(2)}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Qty: ${entry.value.toString()}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  },
                );
              });
            },
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemCount: order.cart!.length,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Price'),
              Text(
                'GH¢ ${order.totalPrice!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          const Text(
            'Delivery location:',
            style: TextStyle(color: Colors.grey),
          ),
          Text(order.locationString!),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
                fixedSize: Size(kScreenWidth(context) - 72, 48),
                backgroundColor: Colors.pink.withOpacity(.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
            onPressed: () async {
              Uri mapUri = Uri.https('www.google.com', '/maps/search/', {
                'api': '1',
                'query':
                    '${order.locationGeo!.latitude.toString()},${order.locationGeo!.longitude.toString()}'
              });

              try {
                if (await canLaunchUrl(mapUri)) {
                  await launchUrl(mapUri);
                } else {
                  showAlertDialog(context);
                }
              } catch (e) {
                showAlertDialog(context);
              }
            },
            child: const Text(
              'View on map',
              style: TextStyle(color: Colors.pink),
            ),
          ),
          const SizedBox(height: 50),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: db.orderDocument(order.id!).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator.adaptive();
                }

                Order currentOrder = Order.fromFirestore(
                    snapshot.data!.data()!, snapshot.data!.id);

                return currentOrder.status != OrderStatus.pending
                    ? const SizedBox()
                    : TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: Size(kScreenWidth(context) - 72, 48),
                            backgroundColor: Colors.red.withOpacity(.3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14))),
                        onPressed: () async {
                          showConfirmationDialog(
                            context,
                            message: 'Cancel order?',
                            confirmFunction: () {
                              db.orderDocument(order.id!).update(
                                  {'status': OrderStatus.canceled.index});
                            },
                          );
                        },
                        child: const Text(
                          'Cancel order',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
              }),
        ],
      ),
    );
  }
}
