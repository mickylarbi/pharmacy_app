import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/checkout/map_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drug_details_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_page.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';
import 'package:pharmacy_app/utils/functions.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController locationStringController = TextEditingController();
  LatLng? locationGeo;

  FirestoreService db = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<Drug, int>>(
        valueListenable: cart,
        builder: (context, value, child) {
          return value.isEmpty
              ? const Center(
                  child: Text(
                  'Items added to cart will show here',
                  style: TextStyle(color: Colors.grey),
                ))
              : ListView(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.value.length,
                      itemBuilder: (context, index) => Slidable(
                        endActionPane: ActionPane(
                          extentRatio: .2,
                          motion: const ScrollMotion(),
                          children: [
                            IconButton(
                              onPressed: () {
                                showConfirmationDialog(
                                  context,
                                  message: 'Remove from cart?',
                                  confirmFunction: () {
                                    deleteFromCart(
                                        cart.value.keys.toList()[index]);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        child: CheckoutCard(
                          entry: cart.value.entries.toList()[index],
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                    ),
                    const SizedBox(height: 30),
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TextField(
                          controller: locationStringController,
                          decoration: const InputDecoration(
                            hintText: 'Delivery location',
                          ),
                        ),
                        const SizedBox(height: 20),
                        StatefulBuilder(builder: (context, setState) {
                          return Center(
                            child: Column(
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      fixedSize: locationGeo == null
                                          ? null
                                          : Size(
                                              kScreenWidth(context) - 72, 48),
                                      backgroundColor: locationGeo == null
                                          ? null
                                          : Colors.pink.withOpacity(.1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14))),
                                  onPressed: () async {
                                    LatLng? result = await navigate(
                                        context,
                                        MapScreen(
                                            initialSelectedPostion:
                                                locationGeo));

                                    if (result != null) {
                                      locationGeo = result;
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    locationGeo == null
                                        ? 'Choose on map'
                                        : 'View on map',
                                    style: locationGeo == null
                                        ? null
                                        : const TextStyle(color: Colors.pink),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (locationGeo != null)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        locationGeo = null;
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Clear geolocation',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Price'),
                            ValueListenableBuilder<Map<Drug, int>>(
                                valueListenable: cart,
                                builder: (context, value, child) {
                                  return Text(
                                    'GH¢ ${calculateTotalPrice().toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          style: elevatedButtonStyle,
                          onPressed: () {
                            Order newOrder = Order(
                              cart: cart.value.map(
                                  (key, value) => MapEntry(key.id!, value)),
                              pharmacyIds: cart.value.keys
                                  .map((e) => e.pharmacyId!)
                                  .toList(),
                              locationGeo: GeoPoint(locationGeo!.latitude,locationGeo!.longitude),
                              locationString:
                                  locationStringController.text.trim(),
                              totalPrice: calculateTotalPrice(),
                              status: OrderStatus.pending,
                              dateTime: DateTime.now(),
                            );

                            if (newOrder.locationString!.isEmpty) {
                              showAlertDialog(context,
                                  message: 'Enter a location for delivery');
                            } else if (newOrder.locationGeo == null) {
                              showAlertDialog(context,
                                  message: 'Choose a location from map');
                            } else {
                              showConfirmationDialog(context,
                                  message: 'Place order?', confirmFunction: () {
                                showLoadingDialog(context,
                                    message: 'Placing order');

                                db
                                    .addOrder(newOrder)
                                    .timeout(ktimeout)
                                    .then((value) {
                                  cart.value = {};
                                  Navigator.pop(context);
                                  // navigate(context, OrdersListScreen());
                                }).onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  showAlertDialog(context,
                                      message: 'Could not place order');
                                });
                              });
                            }
                          },
                          child: const Text('Order medication'),
                        ),
                      ],
                    ),
                  ],
                );
        });
  }

  @override
  void dispose() {
    locationStringController.dispose();
    super.dispose();
  }
}

ValueNotifier<Map<Drug, int>> cart = ValueNotifier<Map<Drug, int>>({});

addToCart(Drug drug) {
  Map<Drug, int> temp = cart.value;
  if (cart.value.keys.contains(drug)) {
    int qty = temp[drug] ?? 0;
    temp[drug] = qty + 1;
  } else {
    temp[drug] = 1;
  }
  cart.value = {...temp};
}

removeFromCart(Drug drug) {
  Map<Drug, int> temp = cart.value;
  if (cart.value.keys.contains(drug)) {
    int qty = temp[drug] ?? 0;

    if (qty == 0 || qty == 1) {
      temp.remove(drug);
    } else {
      temp[drug] = qty - 1;
    }
  }
  cart.value = {...temp};
}

deleteFromCart(Drug drug) {
  if (cart.value.keys.contains(drug)) {
    Map<Drug, int> temp = cart.value;

    temp.remove(drug);
    cart.value = {...temp};
  }
}

calculateTotalPrice() {
  double sum = 0;
  for (MapEntry<Drug, int> entry in cart.value.entries) {
    sum += entry.key.price! * entry.value;
  }
  return sum;
}

class CheckoutCard extends StatelessWidget {
  final MapEntry<Drug, int> entry;
  const CheckoutCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(context, DrugDetailsScreen(drug: entry.key));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 36),
        decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(.2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            DrugImageWidget(
              drugId: entry.key.id!,
              height: 100,
              width: 100,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key.genericName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    entry.key.brandName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'GH¢ ${entry.key.price!.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ValueListenableBuilder<Map<Drug, int>>(
                      valueListenable: cart,
                      builder: (context, value, child) {
                        return Row(
                          children: [
                            IconButton(
                              onPressed: value[entry.key] == 1
                                  ? null
                                  : () {
                                      removeFromCart(entry.key);
                                    },
                              icon: const Icon(Icons.remove_circle),
                            ),
                            Text(value[entry.key].toString()),
                            IconButton(
                              onPressed: value[entry.key]! >=
                                      entry.key.quantityInStock!
                                  ? null
                                  : () {
                                      addToCart(entry.key);
                                    },
                              icon: const Icon(Icons.add_circle),
                            )
                          ],
                        );
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
