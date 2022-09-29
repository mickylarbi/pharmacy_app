import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/compare_drugs_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drug_details_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/pharmacies_list_page.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/functions.dart';

class CompareDrugsSearchDelegate extends SearchDelegate {
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
        ),
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
    List<Drug> temp = (drugListGlobal)
        .where((element) =>
            element.brandName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.brandName!.compareTo(b.brandName!));
    drugsList.addAll(temp);

    temp = (drugListGlobal)
        .where((element) =>
            element.genericName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.genericName!.compareTo(b.genericName!));
    drugsList.addAll(temp.where((element) => !drugsList.contains(element)));

    temp = (drugListGlobal)
        .where((element) =>
            element.group!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    temp.sort((a, b) => a.group!.compareTo(b.group!));
    drugsList.addAll(temp.where((element) => !drugsList.contains(element)));

    return drugsList.isEmpty
        ? const Center(
            child: Text(
            'No drugs to show',
            style: TextStyle(color: Colors.grey),
          ))
        : Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                itemCount: drugsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return CompareDrugCard(drug: drugsList[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 20);
                },
              ),
              const CompareDrugsButton()
            ],
          );
  }
}

class CompareDrugsButton extends StatelessWidget {
  const CompareDrugsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Drug>>(
        valueListenable: compareDrugsNotifier,
        builder: (context, value, child) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: value.length == 1
                    ? null
                    : () {
                        navigate(context, const CompareDrugsScreen());
                      },
                style: elevatedButtonStyle,
                child: const Text('Compare drugs'),
              ),
            ),
          );
        });
  }
}

class CompareDrugCard extends StatelessWidget {
  final Drug drug;
  const CompareDrugCard({super.key, required this.drug});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(
            context,
            DrugDetailsScreen(
              drug: drug,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                DrugImageWidget(
                  drugId: drug.id!,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 20),
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
                          drug.group!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  child: Text('GH¢ ${drug.price!.toStringAsFixed(2)}'),
                ),
                const Spacer(),
                ValueListenableBuilder<List<Drug>>(
                  valueListenable: compareDrugsNotifier,
                  builder: (context, value, child) {
                    return TextButton(
                      onPressed: () {
                        if (!value.contains(drug)) {
                          compareDrugsNotifier.value = [
                            ...compareDrugsNotifier.value,
                            drug
                          ];
                        } else {
                          List<Drug> temp = compareDrugsNotifier.value;
                          temp.remove(drug);
                          compareDrugsNotifier.value = [...temp];
                        }
                      },
                      child: Text(
                        value.contains(drug) ? 'Undo' : 'Compare',
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

ValueNotifier<List<Drug>> compareDrugsNotifier = ValueNotifier([]);
