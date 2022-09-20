import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_page.dart';

class DrugsSearchDelegate extends SearchDelegate {
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
    List<Drug> drugsList = [];
    List<Drug> temp = drugsListNotifier.value
        .where((element) =>
            element.brandName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.brandName!.compareTo(b.brandName!));
    drugsList.addAll(temp);

    temp = drugsListNotifier.value
        .where((element) =>
            element.genericName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.genericName!.compareTo(b.genericName!));
    drugsList.addAll(temp.where((element) => !drugsList.contains(element)));

    temp = drugsListNotifier.value
        .where((element) =>
            element.group!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.group!.compareTo(b.group!));
    drugsList.addAll(temp.where((element) => !drugsList.contains(element)));

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: drugsList.length,
      itemBuilder: (BuildContext context, int index) {
        return DrugCard(drug: drugsList[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
    );
  }
}
