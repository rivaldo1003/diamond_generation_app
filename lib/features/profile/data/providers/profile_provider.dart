import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;
  ProfileProvider({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase;

  Future clearAllData() async {
    await SharedPreferencesManager.clearAllData();
    notifyListeners();
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
