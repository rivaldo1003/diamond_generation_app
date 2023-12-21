import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final String keyFullName = 'full_name';
  static final String keyToken = 'token';
  static final String keyRole = 'role';
  static final String keyAccountNumber = 'account_number';
  static final String keyUserId = 'id';
  static final String keyProfileCompleted = 'profile_completed';
  static final String keyBirthDate = 'birth_date';
  static final String keyGender = 'gender';

  // BIRTH DATE
  static Future<void> saveBirthDate(String birthDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyBirthDate, birthDate);
  }

  static Future<String?> loadBirthDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyBirthDate) ?? '';
  }

//PROFILE_COMPLETED
  static Future<void> saveProfileCompleted(String profileCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyProfileCompleted, profileCompleted);
  }

  static Future<String?> loadProfiledCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyProfileCompleted) ?? '';
  }

//USER ID
  static Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyUserId, userId);
  }

  static Future<String?> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId) ?? '';
  }

//ACCOUNT NUMBER
  static Future<void> saveAccountNumber(String accountNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyAccountNumber, accountNumber);
  }

  static Future<String?> loadAccountNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAccountNumber) ?? '';
  }

//ROLE
  static Future<void> saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyRole, role);
  }

  static Future<String?> loadRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRole) ?? '';
  }

//TOKEN
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyToken, token);
  }

  static Future<String?> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken) ?? '';
  }

//FULL NAME
  static Future<void> saveFullName(String fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyFullName, fullName);
  }

  static Future<String?> loadFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyFullName) ?? '';
  }

// GENDER
  static Future<void> saveGender(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(keyGender, gender);
  }

  static Future<String?> loadGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyGender) ?? '';
  }

//CLEAR DATA
  static Future<void> clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
