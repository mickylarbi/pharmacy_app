import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';

class DrugsSearchDelegate extends SearchDelegate {
  List<Drug> drugsList;
  DrugsSearchDelegate(this.drugsList);
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
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
                )),
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
