import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/drug_details_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class DrugsPage extends StatefulWidget {
  const DrugsPage({super.key});

  @override
  State<DrugsPage> createState() => _DrugsPageState();
}

class _DrugsPageState extends State<DrugsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 20,
      itemBuilder: (context, index) => DrugCard(
        drug: Drug(
            brandName: 'Panadol',
            genericName: 'Paracetamol',
            group: 'Painkillers',
            otherDetails: 'other details',
            price: 20,
            pharmacyId: 'asdkjfi23r'),
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}

class DrugCard extends StatelessWidget {
  final Drug drug;
  const DrugCard({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            DrugDetails(
              drug: drug,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
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
                      drug.pharmacyId!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text('GH¢ ${drug.price!.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
