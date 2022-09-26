import 'package:flutter/material.dart';
import 'package:pharmacy_app/firebase/auth.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/checkout/checkout_page.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_page.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_search_delegate.dart';
import 'package:pharmacy_app/screens/home/orders/order_history_screen.dart';
import 'package:pharmacy_app/screens/home/orders/orders_list_page.dart';
import 'package:pharmacy_app/screens/home/profile/profile_screen.dart';
import 'package:pharmacy_app/utils/constants.dart';
import 'package:pharmacy_app/utils/dialogs.dart';
import 'package:pharmacy_app/utils/functions.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(1);
  final PageController _pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();

    drugsListNotifier = ValueNotifier([]);
  }

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
                    onPressed: () {
                      navigate(
                          context,
                          OrderHistoryScreen(
                              ordersList: ordersList
                                  .where((element) =>
                                      element.status == OrderStatus.canceled ||
                                      element.status == OrderStatus.delivered)
                                  .toList()));
                    },
                    icon: const Icon(Icons.history),
                  ),
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
                if (value == 2)
                  ValueListenableBuilder<Map<Drug, int>>(
                    valueListenable: cart,
                    builder: (context, value, child) {
                      return value.isEmpty
                          ? const SizedBox()
                          : TextButton.icon(
                              onPressed: () {
                                showConfirmationDialog(
                                  context,
                                  message: 'Clear cart?',
                                  confirmFunction: () {
                                    cart.value = {};
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.remove_shopping_cart_rounded,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Clear cart',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                    },
                  ),
              ],
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                OrdersListPage(),
                DrugsPage(),
                CheckoutPage(),
                ProfileScreen()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex.value,
              onTap: (index) {
                if (index != _currentIndex.value) {
                  _currentIndex.value = index;
                  _pageController.jumpToPage(_currentIndex.value);
                }
              },
              selectedIconTheme: const IconThemeData(color: Colors.blue),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.inventory), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
              ],
            ),
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
        return 'Checkout';
      case 3:
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
