import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;

  LoginProvider({
    required GetUserUsecase getUserUsecase,
  }) : _getUserUsecase = getUserUsecase;

//FULL NAME GET SHARED PREFERENCES
  String? _fullName;
  String? get fullName => _fullName;

  bool _obscure = false;
  bool get obscure => _obscure;

// ACCOUNT NUMBER GET SHARED PREFERENCES

  String? _accountNumber;
  String? get accountNumber => _accountNumber;

//USER ID GET SHARED PREFERENCES

//Token GET SHARED PREFERENCES
  String? _token;
  String? get token => _token;

  String? _userId;
  String? get userId => _userId;

  //PROFILE COMPLETED
  String? _profileCompleted;
  String? get profileCompleted => _profileCompleted;

  //BIRTH DATE

  String? _birthDate;
  String? get birthDate => _birthDate;

  // GENDER

  String? _gender;
  String? get gender => _gender;

  // GENDER

  String? _deviceToken;
  String? get deviceToken => _deviceToken;

// TEXTFIELD PASSWORD
  void showPassword() {
    _obscure = !_obscure;
    notifyListeners();
  }

  final keyLogin = GlobalKey<FormState>();

//LOGIN USER
  void loginUser(Map<String, dynamic> body, BuildContext context) {
    _getUserUsecase.loginUser(body, context);
    notifyListeners();
  }

  //BIRTH DATE

  void saveBirthDate(String birthDate) async {
    await SharedPreferencesManager.saveBirthDate(birthDate);
    _birthDate = birthDate;
    notifyListeners();
  }

  Future<String?> loadBirthDate() async {
    _birthDate = await SharedPreferencesManager.loadBirthDate();
    notifyListeners();
  }

//USER ID

  void saveUserId(String userId) async {
    await SharedPreferencesManager.saveUserId(userId);
    _userId = userId;
    notifyListeners();
  }

  Future<String?> loadUserId() async {
    _userId = await SharedPreferencesManager.loadUserId();
    notifyListeners();
  }

//FULL NAME
  void saveFullName(String fullName) async {
    await SharedPreferencesManager.saveFullName(fullName);
    _fullName = fullName;
    notifyListeners();
  }

  Future<String?> loadFullName() async {
    _fullName = await SharedPreferencesManager.loadFullName();
    notifyListeners();
  }

//ROLE
  void saveRole(String role) async {
    await SharedPreferencesManager.saveRole(role);
    notifyListeners();
  }

// TOKEN
  void saveToken(String token) async {
    await SharedPreferencesManager.saveToken(token);
    notifyListeners();
  }

  Future<String?> loadToken() async {
    _token = await SharedPreferencesManager.loadToken();
    notifyListeners();
  }

// ACCOUNT NUMBER
  void saveAccountNumber(String accountNumber) async {
    await SharedPreferencesManager.saveAccountNumber(accountNumber);
    _accountNumber = accountNumber;
    notifyListeners();
  }

  Future<String?> loadAccountNumber() async {
    _accountNumber = await SharedPreferencesManager.loadAccountNumber();
    notifyListeners();
  }

  //PROFILE COMPLETED
  void saveProfileCompleted(String profileCompleted) async {
    await SharedPreferencesManager.saveProfileCompleted(profileCompleted);
    _profileCompleted = profileCompleted;
    notifyListeners();
  }

  Future<String?> loadProfileCompleted() async {
    _profileCompleted = await SharedPreferencesManager.loadProfiledCompleted();
    notifyListeners();
  }

  // GENDER
  void saveGender(String gender) async {
    await SharedPreferencesManager.saveGender(gender);
    _gender = gender;
    notifyListeners();
  }

  Future<String?> loadGender() async {
    _gender = await SharedPreferencesManager.loadGender();
    notifyListeners();
  }

  // DEVICE TOKEN
  void saveDeviceToken(String deviceToken) async {
    await SharedPreferencesManager.saveDeviceToken(deviceToken);
    _deviceToken = deviceToken;
    notifyListeners();
  }

  Future<String?> loadDeviceToken() async {
    _deviceToken = await SharedPreferencesManager.loadDeviceToken();
    notifyListeners();
  }

// CLEAR DATA SHARED PREFERENCES
  void clearAllData() async {
    await SharedPreferencesManager.clearAllData();
    notifyListeners();
  }
}
