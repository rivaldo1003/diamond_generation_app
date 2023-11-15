import 'package:diamond_generation_app/features/bottom_nav_bar/data/providers/bottom_nav_bar_provider.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/home/presentation/bottom_nav_bar_home.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/profile/presentation/bottom_nav_bar_profile.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppMainScreen extends StatelessWidget {
  List<Widget> _screens = [
    BottomNavBarHome(),
    BottomNavBarProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    var bottomNavBarProvider = Provider.of<BottomNaviBarProvider>(context);
    return Scaffold(
      body: _screens.elementAt(bottomNavBarProvider.currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNavBarProvider.currentIndex,
        onTap: (index) {
          bottomNavBarProvider.onTapped(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: MyColor.primaryColor,
        backgroundColor: Colors.grey.shade800,
        selectedLabelStyle: MyFonts.customTextStyle(
          12,
          FontWeight.w500,
          MyColor.blackColor,
        ),
        unselectedLabelStyle: MyFonts.customTextStyle(
          12,
          FontWeight.w500,
          MyColor.blackColor,
        ),
        items: [
          BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
              )),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
