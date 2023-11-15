import 'package:flutter/material.dart';

class BottomNaviBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onTapped(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
