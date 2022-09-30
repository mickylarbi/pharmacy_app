import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/screens/home/checkout/checkout_page.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_list_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/nearby_pharmacies_screen.dart';
import 'package:pharmacy_app/screens/home/drugs/pharmacies_list_page.dart';
import 'package:pharmacy_app/screens/home/drugs/pharmacies_search_delegate.dart';
import 'package:pharmacy_app/screens/home/orders/order_history_screen.dart';
import 'package:pharmacy_app/screens/home/orders/orders_list_page.dart';
import 'package:pharmacy_app/screens/home/orders/reviews_screen.dart';
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
                      navigate(context, const ReviewsScreen());
                    },
                    icon: const Icon(Icons.rate_review_sharp),
                  ),
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
                      if (pharmaciesList.isNotEmpty) {
                        showSearch(
                            context: context,
                            delegate: PharmaciesSearchDelegate());
                      } else {
                        showAlertDialog(context,
                            message: 'No pharmacies to search');
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                if (value == 1)
                  IconButton(
                    onPressed: () {
                      if (pharmaciesList.isNotEmpty) {
                        showLoadingDialog(context);
                        getCurrentLocation().timeout(ktimeout).then((value) {
                          Navigator.pop(context);
                          navigate(
                              context,
                              NearbyPharmaciesScreen(
                                currentLocation: value,
                              ));
                        }).onError((error, stacktrace) {
                          Navigator.pop(context);
                          showAlertDialog(context,
                              message: 'Could not get current location');
                        });
                      } else {
                        Navigator.pop(context);
                        showAlertDialog(context,
                            message: 'No pharmacies to show');
                      }
                    },
                    icon: const Icon(Icons.location_pin),
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
                PharmaciesListPage(),
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
        return 'Pharmacies';
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
