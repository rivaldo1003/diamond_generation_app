import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:flutter/material.dart';

class WpdaProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;

  WpdaProvider({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase;

  void createWpda(Map<String, dynamic> body, BuildContext context) async {
    await _getUserUsecase.createWpda(body, context);
    notifyListeners();
  }

  List<WPDA> wpdas = [];
  Future refreshAllUsers() async {
    wpdas = await _getUserUsecase.getAllWpda();
    notifyListeners();
  }
}
