import 'package:clean_architecture/presentation/main/pages/home_page,.dart';
import 'package:clean_architecture/presentation/main/pages/notifications_page.dart';
import 'package:clean_architecture/presentation/main/pages/search_page.dart';
import 'package:clean_architecture/presentation/main/pages/settings.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/constants_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

List<Widget> pages = const [
  HomePage(),
  SearchPage(),
  NotificationsPage(),
  SettingsPage(),
];
List<String> pageTitles = const [
  AppStrings.home,
  AppStrings.search,
  AppStrings.notifications,
  AppStrings.settings,
];
int currentIndex = 0;

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[currentIndex],
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor: ColorManager.primary,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.lightGray, spreadRadius: AppSizes.s1_5)
        ]),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: AppStrings.home),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: AppStrings.search),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: AppStrings.notifications),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: AppStrings.settings),
          ],
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: currentIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
