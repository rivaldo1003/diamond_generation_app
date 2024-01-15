import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:flutter/material.dart';

class VerifiedEmailProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;

  VerifiedEmailProvider({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase;

  void verifyUser(Map<String, dynamic> body, BuildContext context, token) {
    _getUserUsecase.verifyUser(
      context,
      body,
      token,
    );
    notifyListeners();
  }
}
