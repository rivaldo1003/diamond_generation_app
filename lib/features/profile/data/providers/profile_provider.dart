import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;
  ProfileProvider({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase;

  final keyImageProfile = "image_profile";
  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil nilai keyImageProfile
    String? imageProfile = prefs.getString(keyImageProfile);

    // Bersihkan semua data
    await prefs.clear();

    // // Set ulang nilai keyImageProfile
    // if (imageProfile != null) {
    //   await prefs.setString(keyImageProfile, imageProfile);
    // }
  }

  Future updateProfile(
    BuildContext context,
    Map<String, dynamic> body,
    String userId,
    String token,
  ) async {
    await _getUserUsecase.updateProfile(userId, context, token, body);
    // Future.delayed(Duration(seconds: 2), () {
    //   // notifyListeners();
    // });
  }

  Future refreshProfile(int userId, String token) async {
    _getUserUsecase.getUserProfile(userId, token);
    notifyListeners();
  }

  TextEditingController _controller = TextEditingController();

  TextEditingController get controller => _controller;

  void sendData(String value) {
    _controller.text = value;
    // notifyListeners();
  }
}
