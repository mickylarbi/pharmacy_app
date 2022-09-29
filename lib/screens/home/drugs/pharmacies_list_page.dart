import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmacy_app/firebase/firestore.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/pharmacy.dart';
import 'package:pharmacy_app/screens/home/drugs/drug_details_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_screen.dart';
import 'package:pharmacy_app/screens/home/profile/profile_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class PharmaciesListPage extends StatelessWidget {
  const PharmaciesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Drug> drugsList = [];
    List<String> pharmacyIds = [];

    FirestoreService db = FirestoreService();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.drugsCollection.snapshots(),
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
                'Nothing to see here',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          for (Drug element in drugsList) {
            if (!pharmacyIds.contains(element.pharmacyId)) {
              pharmacyIds.add(element.pharmacyId!);
            }
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: pharmacyIds.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 14),
            itemBuilder: (BuildContext context, int index) =>
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: db.pharmacyDocument(pharmacyIds[index]).get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Reload'),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Pharmacy pharmacy = Pharmacy.fromFirestore(
                            snapshot.data!.data()!, snapshot.data!.id);

                        return PharmacyCard(
                          pharmacy: pharmacy,
                          drugsList: drugsList
                              .where((element) =>
                                  element.pharmacyId == pharmacy.id)
                              .toList(),
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }),
          );
        });
  }
}

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;
  final List<Drug> drugsList;
  const PharmacyCard({
    Key? key,
    required this.pharmacy,
    required this.drugsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            DrugsListscreen(
              pharmacy: pharmacy,
              pharmacyDrugsList: drugsList,
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
            ProfileImageWidget(
              userId: pharmacy.id,
              height: 100,
              width: 100,
            ),
            const SizedBox(width: 20),
            Text(pharmacy.name!),
          ],
        ),
      ),
    );
  }
}
