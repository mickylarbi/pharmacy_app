import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_page.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_search_delegate.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_drugs/pharmacy_drugs_list_page.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_drugs/edit_drug_details_screen.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_orders/order_history_screen.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/manage_orders/orders_list_page.dart';
import 'package:pharmacy_app/screens/manage_pharmacy/profile/pharmacy_profile_screen.dart';
import 'package:pharmacy_app/utils/functions.dart';

class PharmacyTabView extends StatefulWidget {
  const PharmacyTabView({super.key});

  @override
  State<PharmacyTabView> createState() => _PharmacyTabViewState();
}

class _PharmacyTabViewState extends State<PharmacyTabView> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _currentIndex,
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle()),
              centerTitle: false,
              actions: [
                if (value == 0)
                  IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {
                        navigate(context, OrderHistoryScreen());
                      }),
                if (value == 1)
                  IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: DrugsSearchDelegate());
                    },
                    icon: const Icon(Icons.search),
                  ),
                if (value == 1)
                  PopupMenuButton(
                    icon: const Icon(Icons.sort),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sort by',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListTile(
                              title: const Text('Brand name'),
                              onTap: () {
                                List<Drug> temp = drugsListNotifier.value;
                                temp.sort(((a, b) =>
                                    a.brandName!.compareTo(b.brandName!)));

                                drugsListNotifier.value = [...temp];
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Generic name'),
                              onTap: () {
                                List<Drug> temp = drugsListNotifier.value;
                                temp.sort(((a, b) =>
                                    a.genericName!.compareTo(b.genericName!)));

                                drugsListNotifier.value = [...temp];
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Class'),
                              onTap: () {
                                List<Drug> temp = drugsListNotifier.value;
                                temp.sort(
                                    ((a, b) => a.group!.compareTo(b.group!)));

                                drugsListNotifier.value = [...temp];
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Price'),
                              onTap: () {
                                List<Drug> temp = drugsListNotifier.value;
                                temp.sort(
                                    ((a, b) => a.price!.compareTo(b.price!)));

                                drugsListNotifier.value = [...temp];
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
              ],
            ),
            body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  PharmacyOrdersListPage(),
                  PharmacyDrugsListPage(),
                  PharmacyProfileScreen()
                ]),
            bottomNavigationBar: ValueListenableBuilder<int>(
                //TODO: create custom
                valueListenable: _currentIndex,
                builder: (context, value, child) {
                  return BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex.value,
                    onTap: (index) {
                      if (index != _currentIndex.value) {
                        _currentIndex.value = index;
                        _pageController.jumpToPage(_currentIndex.value);
                      }
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart_checkout_rounded),
                          label: ''),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.medication_rounded), label: ''),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), label: ''),
                    ],
                  );
                }),
            floatingActionButton: _currentIndex.value == 1
                ? FloatingActionButton(
                    onPressed: () {
                      navigate(context, const EditDrugDetailsScreen());
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        });
  }

  String appBarTitle() {
    switch (_currentIndex.value) {
      case 0:
        return 'Orders';
      case 1:
        return 'Drugs';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndex.dispose();

    super.dispose();
  }
}
