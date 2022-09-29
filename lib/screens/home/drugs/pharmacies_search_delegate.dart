import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/pharmacy.dart';
import 'package:pharmacy_app/screens/home/drugs/pharmacies_list_page.dart';

class PharmaciesSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {},
          icon: IconButton(
            onPressed: () {
              query = '';
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 10,
              child: Center(
                child: Icon(
                  Icons.clear,
                  color: Colors.black,
                  size: 14,
                ),
              ),
            ),
          ),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return body();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return body();
  }

  Widget body() {
    List<Pharmacy> searchHits = pharmaciesList
        .where(
          (element) => element.name!.contains(query),
        )
        .toList();

    searchHits.sort(
      (a, b) => a.name!.compareTo(b.name!),
    );
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: searchHits.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) => PharmacyCard(
          pharmacy: searchHits[index],
          drugsList: drugListGlobal!
              .where((element) => element.pharmacyId == searchHits[index].id)
              .toList()),
    );
  }
}
