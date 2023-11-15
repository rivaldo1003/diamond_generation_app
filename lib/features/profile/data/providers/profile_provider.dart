import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  Future clearAllData() async {
    await SharedPreferencesManager.clearAllData();
    notifyListeners();
  }
}
