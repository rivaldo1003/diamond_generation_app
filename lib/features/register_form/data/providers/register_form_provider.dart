import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Gender { Male, Female }

class RegisterFormProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;

  String placeOfBirth = '';
  DateTime selectedDateOfBirth = DateTime.now();

  Gender _selectedGender;

  RegisterFormProvider({required GetUserUsecase getUserUsecase})
      : _getUserUsecase = getUserUsecase,
        _selectedGender = Gender.Male;

  Gender get selectedGender => _selectedGender;

  set selectedGender(Gender gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  bool showRequiredMessageFullName = false;
  bool showRequiredMessageAddress = false;
  bool showRequiredMessagePhoneNumber = false;
  bool showRequiredMessagePlaceOfBirth = false;

  TextEditingController addressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode placeOfBirthFocusNode = FocusNode();

  void validateInput() {
    showRequiredMessageFullName = fullNameController.text.isEmpty;
    showRequiredMessageAddress = addressController.text.isEmpty;
    showRequiredMessagePhoneNumber = phoneNumberController.text.isEmpty;
    showRequiredMessagePlaceOfBirth = placeOfBirthController.text.isEmpty;
    notifyListeners();
  }

  void onSubmit(Map<String, dynamic> body, BuildContext context) {
    validateInput();

    if (!showRequiredMessageAddress &&
        !showRequiredMessagePhoneNumber &&
        !showRequiredMessagePlaceOfBirth) {
      //SUCCESS
      _getUserUsecase.submitDataUser(body, context);
    }
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateOfBirth,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDateOfBirth) {
      selectedDateOfBirth = picked;
      notifyListeners();
    }
  }

  String formatDate() {
    return DateFormat('yyyy/MM/dd').format(selectedDateOfBirth);
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
