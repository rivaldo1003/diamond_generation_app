import 'package:flutter/material.dart';

class ViewAllDataProvider with ChangeNotifier {
  bool _isKeyboardVisible = false;
  bool get isKeyboardVisible => _isKeyboardVisible;
  void setKeyboardVisibility(bool value) {
    _isKeyboardVisible = value;
    notifyListeners();
  }
}
