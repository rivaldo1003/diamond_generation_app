import 'package:diamond_generation_app/features/history_wpda/presentation/history_screen.dart';
import 'package:diamond_generation_app/features/home/presentation/home_screen.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/profile/presentation/profile_screen.dart';
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
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        child: BottomNavigationBar(
          currentIndex: selected,
          onTap: (value) {
            setState(() {
              selected = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MyColor.primaryColor,
          backgroundColor: Colors.grey.shade800,
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
                        ? SvgPicture.asset('assets/icons/home_active.svg')
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
                        ? SvgPicture.asset('assets/icons/profil_active.svg')
                        : SvgPicture.asset('assets/icons/profil_nonactive.svg'),
                    label: 'Akun',
                  ),
                ]
              : [
                  BottomNavigationBarItem(
                    label: 'WPDA',
                    icon: (selected == 0) ? Icon(Icons.book) : Icon(Icons.book),
                  ),
                  BottomNavigationBarItem(
                    label: 'Riwayat',
                    icon: (selected == 1)
                        ? Icon(Icons.history)
                        : Icon(Icons.history),
                  ),
                  BottomNavigationBarItem(
                    icon: (selected == 2)
                        ? SvgPicture.asset('assets/icons/profil_active.svg')
                        : SvgPicture.asset('assets/icons/profil_nonactive.svg'),
                    label: 'Akun',
                  ),
                ],
        ),
      ),
      body: (role == "admin")
          ? bodyAdmin.elementAt(selected)
          : bodyUser.elementAt(selected),
    );
  }
}
