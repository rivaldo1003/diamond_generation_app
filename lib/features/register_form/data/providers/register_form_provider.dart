import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender { Male, Female }

class RegisterFormProvider with ChangeNotifier {
  final GetUserUsecase _getUserUsecase;
  bool _isMarried = false;

  bool get isMarried => _isMarried;

  void updateIsMarried(value) {
    _isMarried = value;
    notifyListeners();
  }

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
  bool showRequiredMessagePartner = false;
  bool showRequiredMessageChildren = false;

  TextEditingController addressController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController partnerController = TextEditingController();
  TextEditingController childrenController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode placeOfBirthFocusNode = FocusNode();
  FocusNode PartnerFocusNode = FocusNode();
  FocusNode childrenFocusNode = FocusNode();

  void validateInput() {
    showRequiredMessageFullName = fullNameController.text.isEmpty;
    showRequiredMessageAddress = addressController.text.isEmpty;
    showRequiredMessagePhoneNumber = phoneNumberController.text.isEmpty;
    showRequiredMessagePlaceOfBirth = placeOfBirthController.text.isEmpty;
    showRequiredMessagePartner = partnerController.text.isEmpty;
    showRequiredMessageChildren = childrenController.text.isEmpty;
    notifyListeners();
  }

  void onSubmit(
    Map<String, dynamic> body,
    BuildContext context,
    String token,
    String id,
  ) {
    validateInput();

    if (isMarried) {
      if (!showRequiredMessageAddress &&
          !showRequiredMessagePhoneNumber &&
          !showRequiredMessagePlaceOfBirth &&
          !showRequiredMessageChildren &&
          !showRequiredMessagePartner) {
        _getUserUsecase.submitDataUser(
          body,
          context,
          token,
          id,
        );
      }
    } else {
      if (!showRequiredMessageAddress &&
          !showRequiredMessagePhoneNumber &&
          !showRequiredMessagePlaceOfBirth) {
        _getUserUsecase.submitDataUser(
          body,
          context,
          token,
          id,
        );
      }
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

      // Hitung umur berdasarkan tanggal lahir yang baru
      int umur = calculateAge(selectedDate);

      // Simpan selectedDateOfBirth dan umur ke shared preferences
      await saveBirthDateAndAgeToPreferences(
          selectedDate.toIso8601String(), umur);

      // Panggil notifyListeners() untuk memberi tahu widget terkait perubahan
      notifyListeners();
    } else {
      // Jika pengguna membatalkan, muat ulang selectedDateOfBirth dan umur dari shared preferences
      await loadBirthDateAndAgeFromPreferences();
    }
  }

  // Metode untuk menyimpan birthDate dan umur ke shared preferences
  Future<void> saveBirthDateAndAgeToPreferences(
      String birthDate, int age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('birth_date', birthDate);
    prefs.setInt('age', age);
  }

  Future<void> loadBirthDateAndAgeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedBirthDate = prefs.getString('birth_date');
    int? storedAge = prefs.getInt('age');

    if (storedBirthDate != null && storedAge != null) {
      selectedDateOfBirth = DateTime.parse(storedBirthDate);
      // Jika Anda membutuhkan akses ke umur di kelas, Anda dapat menyimpannya di sini.
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
