import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pharmacy_app/screens/home/drugs/drugs_page.dart';
import 'package:pharmacy_app/screens/home/orders/orders_page.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _currentIndex,
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(value == 0 ? 'Orders' : 'Inventory'),
              actions: [
                if (value == 1)
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
            ),
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                OrdersPage(),
                DrugsPage(),
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
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndex.dispose();

    super.dispose();
  }
}
