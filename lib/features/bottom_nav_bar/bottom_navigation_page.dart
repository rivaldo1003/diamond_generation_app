import 'package:diamond_generation_app/features/history_wpda/presentation/history_screen.dart';
import 'package:diamond_generation_app/features/home/presentation/home_screen.dart';
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
  final int? index;

  BottomNavigationPage({
    this.index,
  });
  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  String? role;
  int selected = 0;

  Future<void> goToHome() async {
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
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        color: Colors.grey.shade800,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: selected,
          onTap: (value) {
            setState(() {
              selected = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MyColor.greyText,
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
          selectedFontSize: 12, // ukuran font untuk item yang dipilih
          unselectedFontSize: 12, // ukuran font untuk item yang tidak dipilih
          // menambahkan jarak antara ikon dan label untuk item yang dipilih
          items: (role == 'admin' || role == 'super_admin')
              ? [
                  BottomNavigationBarItem(
                      label: 'Beranda',
                      icon: (selected == 0)
                          ? SvgPicture.asset(
                              'assets/bottom_navbar/home.svg',
                              color: MyColor.primaryColor,
                              height: 20,
                            )
                          : SvgPicture.asset(
                              'assets/bottom_navbar/home.svg',
                              color: MyColor.greyText,
                              height: 20,
                            )),
                  BottomNavigationBarItem(
                      label: 'WPDA',
                      icon: (selected == 1)
                          ? SvgPicture.asset(
                              'assets/bottom_navbar/book.svg',
                              color: MyColor.primaryColor,
                              height: 20,
                            )
                          : SvgPicture.asset(
                              'assets/bottom_navbar/book.svg',
                              color: MyColor.greyText,
                              height: 20,
                            )),
                  BottomNavigationBarItem(
                      label: 'Riwayat',
                      icon: (selected == 2)
                          ? SvgPicture.asset(
                              'assets/bottom_navbar/riwayat.svg',
                              color: MyColor.primaryColor,
                              height: 20,
                            )
                          : SvgPicture.asset(
                              'assets/bottom_navbar/riwayat.svg',
                              color: MyColor.greyText,
                              height: 20,
                            )),
                  BottomNavigationBarItem(
                    icon: (selected == 3)
                        ? SvgPicture.asset(
                            'assets/bottom_navbar/profile.svg',
                            color: MyColor.primaryColor,
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/bottom_navbar/profile.svg',
                            color: MyColor.greyText,
                            height: 20,
                          ),
                    label: 'Akun',
                  ),
                ]
              : [
                  BottomNavigationBarItem(
                    label: 'WPDA',
                    icon: (selected == 0)
                        ? SvgPicture.asset(
                            'assets/bottom_navbar/book.svg',
                            color: MyColor.primaryColor,
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/bottom_navbar/book.svg',
                            color: MyColor.greyText,
                            height: 20,
                          ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Riwayat',
                    icon: (selected == 1)
                        ? SvgPicture.asset(
                            'assets/bottom_navbar/riwayat.svg',
                            color: MyColor.primaryColor,
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/bottom_navbar/riwayat.svg',
                            color: MyColor.greyText,
                            height: 20,
                          ),
                  ),
                  BottomNavigationBarItem(
                    icon: (selected == 2)
                        ? SvgPicture.asset(
                            'assets/bottom_navbar/profile.svg',
                            color: MyColor.primaryColor,
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/bottom_navbar/profile.svg',
                            color: MyColor.greyText,
                            height: 20,
                          ),
                    label: 'Akun',
                  ),
                ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: (role == "admin" || role == 'super_admin')
            ? bodyAdmin[selected]
            : bodyUser[selected],
      ),
      floatingActionButton: (role == 'admin' || role == 'super_admin'
              ? selected == 1
              : selected == 0)
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
          ((role == 'admin' || role == 'super_admin') && selected == 1)
              ? FloatingActionButtonLocation.centerDocked
              : null,
    );
  }
}
