import 'package:flutter/material.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_page.dart';
import 'package:pharmacy_app/utils/constants.dart';

class PharmacyDrugDetailsScreen extends StatelessWidget {
  final Drug drug;
  final bool showButton;
  PharmacyDrugDetailsScreen({Key? key, required this.drug, this.showButton = false})
      : super(key: key);

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
    );
  }
}
