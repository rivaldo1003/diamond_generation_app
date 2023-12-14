import 'package:diamond_generation_app/features/bottom_nav_bar/bottom_navigation_page.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../login/presentation/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _splashScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(
      SharedPreferencesManager.keyToken,
    );
    String? role = prefs.getString(SharedPreferencesManager.keyRole);
    String? profileCompleted =
        prefs.getString(SharedPreferencesManager.keyProfileCompleted);
    print(token);
    print(role);
    print(profileCompleted);
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        if (token != null && role == 'admin') {
          return BottomNavigationPage();
        } else if (token != null && role == 'user' && profileCompleted == '1') {
          return BottomNavigationPage();
        } else {
          return LoginScreen();
        }
      }));
    });
  }

  @override
  void initState() {
    _splashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Center(
              child: Shimmer.fromColors(
                baseColor: Colors.amber, // Warna latar belakang shimmer
                highlightColor: Colors.grey.shade300,
                child: Image.asset(
                  'assets/images/title.png',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
