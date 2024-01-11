import 'package:diamond_generation_app/features/history_wpda/presentation/history_screen.dart';
import 'package:diamond_generation_app/features/home/presentation/home_screen.dart';
import 'package:diamond_generation_app/features/home/presentation/home_screen_user.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/profile/presentation/profile_screen.dart';
import 'package:diamond_generation_app/features/wpda/presentation/add_wpda.dart';
import 'package:diamond_generation_app/features/wpda/presentation/wpda_screen.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationPage extends StatefulWidget {
  int? index;

  BottomNavigationPage({
    this.index,
  });
  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  String? role;
  int selected = 0;

  Future goToHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString(SharedPreferencesManager.keyRole);
      print(role);
    });
  }

  List<Widget> bodyAdmin = [
    HomeScreen(),
    WPDAScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];
  List<Widget> bodyUser = [
    HomeScreenUser(),
    WPDAScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    goToHome();
    if (widget.index != null) {
      selected = widget.index!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        color: Colors.grey.shade800,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: selected,
          onTap: (value) {
            setState(() {
              selected = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MyColor.primaryColor,
          selectedLabelStyle: MyFonts.customTextStyle(
            12,
            FontWeight.bold,
            MyColor.blackColor,
          ),
          unselectedLabelStyle: MyFonts.customTextStyle(
            12,
            FontWeight.w500,
            MyColor.blackColor,
          ),
          items: (role == 'admin')
              ? [
                  BottomNavigationBarItem(
                    label: 'Beranda',
                    icon: (selected == 0)
                        ? SvgPicture.asset(
                            'assets/icons/home_active.svg',
                          )
                        : SvgPicture.asset('assets/icons/home_nonactive.svg'),
                  ),
                  BottomNavigationBarItem(
                    label: 'WPDA',
                    icon: (selected == 1) ? Icon(Icons.book) : Icon(Icons.book),
                  ),
                  BottomNavigationBarItem(
                    label: 'Riwayat',
                    icon: (selected == 2)
                        ? Icon(Icons.history)
                        : Icon(Icons.history),
                  ),
                  BottomNavigationBarItem(
                    icon: (selected == 3)
                        ? SvgPicture.asset(
                            'assets/icons/profil_active.svg',
                            color: MyColor.primaryColor,
                          )
                        : SvgPicture.asset('assets/icons/profil_nonactive.svg'),
                    label: 'Akun',
                  ),
                ]
              : [
                  BottomNavigationBarItem(
                    label: 'Beranda',
                    icon: (selected == 0)
                        ? SvgPicture.asset(
                            'assets/icons/home_active.svg',
                          )
                        : SvgPicture.asset('assets/icons/home_nonactive.svg'),
                  ),
                  BottomNavigationBarItem(
                    label: 'WPDA',
                    icon: (selected == 1) ? Icon(Icons.book) : Icon(Icons.book),
                  ),
                  BottomNavigationBarItem(
                    label: 'Riwayat',
                    icon: (selected == 2)
                        ? Icon(Icons.history)
                        : Icon(Icons.history),
                  ),
                  BottomNavigationBarItem(
                    icon: (selected == 3)
                        ? SvgPicture.asset(
                            'assets/icons/profil_active.svg',
                            color: MyColor.primaryColor,
                          )
                        : SvgPicture.asset('assets/icons/profil_nonactive.svg'),
                    label: 'Akun',
                  ),
                ],
        ),
      ),
      body: (role == "admin")
          ? bodyAdmin.elementAt(selected)
          : bodyUser.elementAt(selected),
      floatingActionButton: (selected == 1)
          ? FloatingActionButton(
              backgroundColor: MyColor.primaryColor,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddWPDAForm();
                }));
              },
              child: Icon(Icons.add),
              shape: CircleBorder(), // Memberikan bentuk lingkaran pada FAB
            )
          : SizedBox(),
      floatingActionButtonLocation:
          (selected == 1) ? FloatingActionButtonLocation.centerDocked : null,
    );
  }
}
