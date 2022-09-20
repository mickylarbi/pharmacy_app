import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_page.dart';
import 'package:pharmacy_app/utils/constants.dart';

class DrugDetails extends StatefulWidget {
  final Drug drug;
  const DrugDetails({super.key, required this.drug});

  @override
  State<DrugDetails> createState() => _DrugDetailsState();
}

class _DrugDetailsState extends State<DrugDetails> {
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
                        drugId: widget.drug.id!,
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
                      Text(widget.drug.brandName!),
                      const SizedBox(height: 20),
                      Text(
                        'General name',
                        style: labelTextStyle,
                      ),
                      Text(widget.drug.genericName!),
                      const SizedBox(height: 20),
                      Text(
                        'Class',
                        style: labelTextStyle,
                      ),
                      Text(widget.drug.group!),
                      const SizedBox(height: 20),
                      Text(
                        'Price',
                        style: labelTextStyle,
                      ),
                      Text('GH¢ ${widget.drug.price!.toStringAsFixed(2)}'),
                      const SizedBox(height: 20),
                      Text(
                        'Other details',
                        style: labelTextStyle,
                      ),
                      Text(widget.drug.otherDetails!),
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
              child: ElevatedButton.icon(
                  onPressed: () {},
                  style: elevatedButtonStyle,
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add to cart')),
            ),
          )
        ],
      ),
    );
  }
}
