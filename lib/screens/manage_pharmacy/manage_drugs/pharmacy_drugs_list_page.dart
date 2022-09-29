import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/firebase/storage.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_screen.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_drugs/edit_drug_details_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class PharmacyDrugsListPage extends StatefulWidget {
  const PharmacyDrugsListPage({Key? key}) : super(key: key);

  @override
  State<PharmacyDrugsListPage> createState() => _PharmacyDrugsListPageState();
}

class _PharmacyDrugsListPageState extends State<PharmacyDrugsListPage> {
  FirestoreService db = FirestoreService();

  List<Drug> drugsList = [];
  List<String> groups = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.myDrugs.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Reload'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        drugsList = snapshot.data!.docs
            .map((e) => Drug.fromFirestore(e.data(), e.id))
            .toList();

        if (drugsList.isEmpty) {
          return const Center(
            child: Text(
              'Tap the + icon to add a drug',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        Map<String, List<Drug>> categories = {};

        for (Drug element in drugsList) {
          if (categories[element.group] == null) {
            categories[element.group!] = [element];
          } else {
            categories[element.group!]!.add(element);
          }
        }

        groups = categories.keys.toList()..sort();

        groups.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: groups.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 50);
          },
          itemBuilder: (BuildContext context, int index) {
            List<Drug> categoryList = categories[groups[index]]!;
            //TODO; sort by brand name then generic name
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groups[index],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: .8,
                  ),
                  itemCount: categoryList.length,
                  itemBuilder: (BuildContext context, int categoryIndex) {
                    return DrugCard(
                      drug: categoryList[categoryIndex],
                    );
                  },
                ),
              ],
            );
          },
        );
      },
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
        navigate(context, EditDrugDetailsScreen(drug: drug));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: Center(child: DrugImageWidget(drugId: drug.id!))),
            const SizedBox(height: 10),
            Text(
              drug.genericName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              drug.brandName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'GH¢ ${drug.price!.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

