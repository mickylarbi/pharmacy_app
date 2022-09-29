import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/compare_drugs_search_delegate.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_screen.dart';
import 'package:pharmacy_app/utils/constants.dart';

class CompareDrugsScreen extends StatefulWidget {
  const CompareDrugsScreen({super.key});

  @override
  State<CompareDrugsScreen> createState() => _CompareDrugsScreenState();
}

class _CompareDrugsScreenState extends State<CompareDrugsScreen> {
  PageController pageController = PageController();
  ValueNotifier<int> currentPage = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      currentPage.value = pageController.page!.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: currentPage,
          builder: (context, value, child) {
            return Text(
                '${currentPage.value + 1}/${compareDrugsNotifier.value.length}');
          },
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: compareDrugsNotifier.value.length,
            itemBuilder: (context, index) {
              Drug drug = compareDrugsNotifier.value[index];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: DrugImageWidget(
                        drugId: drug.id!,
                        height: 200,
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 20),
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
              );
            },
          ),
          ValueListenableBuilder(
              valueListenable: currentPage,
              builder: (context, value, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 38, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (value != 0)
                          ElevatedButton(
                            onPressed: () {
                              pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutQuint);
                              setState(() {});
                            },
                            child: const Text('Previous'),
                          ),
                        const Spacer(),
                        if (value < compareDrugsNotifier.value.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutQuint);
                              setState(() {});
                            },
                            child: const Text('Next'),
                          ),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
