import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void onSubmit(
    Map<String, dynamic> body,
    BuildContext context,
    String token,
    String id,
  ) {
    validateInput();

    if (!showRequiredMessageAddress &&
        !showRequiredMessagePhoneNumber &&
        !showRequiredMessagePlaceOfBirth) {
      //SUCCESS
      _getUserUsecase.submitDataUser(
        body,
        context,
        token,
        id,
      );
    }
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context, {String? initialDate}) async {
    DateTime currentDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:
          initialDate != null ? DateTime.parse(initialDate) : currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (selectedDate != null && selectedDate != selectedDateOfBirth) {
      // Perbarui selectedDateOfBirth sesuai dengan tanggal yang dipilih
      selectedDateOfBirth = selectedDate;

      // Simpan selectedDateOfBirth ke shared preferences
      await saveBirthDateToPreferences(selectedDate.toIso8601String());

      // Panggil notifyListeners() untuk memberi tahu widget terkait perubahan
      notifyListeners();
    } else {
      // Jika pengguna membatalkan, muat ulang selectedDateOfBirth dari shared preferences
      await loadBirthDateFromPreferences();
    }
  }

  // Metode untuk menyimpan birthDate ke shared preferences
  Future<void> saveBirthDateToPreferences(String birthDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('birth_date', birthDate);
  }

  Future<void> loadBirthDateFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedBirthDate = prefs.getString('birth_date');

    if (storedBirthDate != null) {
      selectedDateOfBirth = DateTime.parse(storedBirthDate);
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
