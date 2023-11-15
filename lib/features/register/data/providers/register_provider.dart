import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_register.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;

  RegisterProvider({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase;

  bool _obscure = false;
  bool get obscure => _obscure;

  void showPassword() {
    _obscure = !obscure;
    notifyListeners();
  }

  final keyRegister = GlobalKey<FormState>();

  @override
  void dispose() {
    TextFieldControllerRegister.fullNameController.dispose();
    TextFieldControllerRegister.emailController.dispose();
    TextFieldControllerRegister.passwordController.dispose();
    super.dispose();
  }

  void registerUser(Map<String, dynamic> body, BuildContext context) async {
    await _getUserUsecase.registerUser(body, context);
    notifyListeners();
  }
}
