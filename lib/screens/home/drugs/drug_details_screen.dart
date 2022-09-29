import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/checkout/checkout_page.dart';
import 'package:pharmacy_app/screens/home/drugs/compare_drugs_search_delegate.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_screen.dart';
import 'package:pharmacy_app/utils/constants.dart';

class DrugDetailsScreen extends StatelessWidget {
  final Drug drug;
  const DrugDetailsScreen({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: kScreenWidth(context),
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      DrugImageWidget(
                        drugId: drug.id!,
                        borderRadius: 0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(.55),
                              Colors.black.withOpacity(.0),
                              Colors.black.withOpacity(.0),
                              Colors.black.withOpacity(.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Brand name',
                        style: labelTextStyle,
                      ),
                      Text(drug.brandName!),
                      const SizedBox(height: 20),
                      Text(
                        'General name',
                        style: labelTextStyle,
                      ),
                      Text(drug.genericName!),
                      const SizedBox(height: 20),
                      Text(
                        'Class',
                        style: labelTextStyle,
                      ),
                      Text(drug.group!),
                      const SizedBox(height: 20),
                      Text(
                        'Price',
                        style: labelTextStyle,
                      ),
                      Text('GH¢ ${drug.price!.toStringAsFixed(2)}'),
                      const SizedBox(height: 20),
                      Text(
                        'Other details',
                        style: labelTextStyle,
                      ),
                      Text(drug.otherDetails!),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ValueListenableBuilder<List<Drug>>(
                      valueListenable: compareDrugsNotifier,
                      builder: (context, value, child) {
                        return ElevatedButton(
                          onPressed: value.contains(drug)
                              ? null
                              : () async {
                                  compareDrugsNotifier.value = [drug];

                                  await showSearch(
                                      context: context,
                                      delegate: CompareDrugsSearchDelegate());

                                  compareDrugsNotifier.value = [];
                                },
                          style: elevatedButtonStyle,
                          child: const Text('Compare'),
                        );
                      }),
                  if (drug.quantityInStock! > 0) const SizedBox(width: 20),
                  if (drug.quantityInStock! > 0)
                    ValueListenableBuilder<Map<Drug, int>>(
                      valueListenable: cart,
                      builder: (context, value, child) {
                        Color? color = value.keys.contains(drug)
                            ? Colors.orange
                            : Colors.green;
                        return ElevatedButton.icon(
                            onPressed: () {
                              if (value.keys.contains(drug)) {
                                deleteFromCart(drug);
                              } else {
                                addToCart(drug);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: color,
                            ),
                            icon: Icon(
                              value.keys.contains(drug)
                                  ? Icons.delete
                                  : Icons.add_shopping_cart,
                            ),
                            label: Text(value.keys.contains(drug)
                                ? 'Remove from cart'
                                : 'Add to cart'));
                      },
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
