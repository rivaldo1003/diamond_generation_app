import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class WpdaProvider with ChangeNotifier {
  final GetWpdaUsecase _getWpdaUsecase;

  WpdaProvider({required GetWpdaUsecase getWpdaUsecase})
      : _getWpdaUsecase = getWpdaUsecase,
        readingBookController = TextEditingController(),
        verseContentController = TextEditingController(),
        messageOfGodController = TextEditingController(),
        applicationInLifeController = TextEditingController();

  void createWpda(
      Map<String, dynamic> body, BuildContext context, String token) async {
    await _getWpdaUsecase.createWpda(body, context, token);
    notifyListeners();
  }

  @override
  void dispose() {
    applicationInLifeController.dispose();
    verseContentController.dispose();
    readingBookController.dispose();
    messageOfGodController.dispose();
    super.dispose();
  }

  List<WPDA> wpdas = [];
  var history;
  List<HistoryWpda> historyWpda = [];

  Future refreshAllUsers() async {
    // wpdas = await _getWpdaUsecase.getAllWpda();
    notifyListeners();
  }

  Future refreshWpdaHistory(String userId) async {
    // await _getWpdaUsecase.getAllWpdaByUserID(userId);
    notifyListeners();
  }

  bool showRequiredMessageReadingBook = false;
  bool showRequiredMessageVerseContent = false;
  bool showRequiredMessageMessageOfGod = false;
  bool showRequiredMessageApplicationInLife = false;

  late TextEditingController readingBookController;
  late TextEditingController verseContentController;
  late TextEditingController messageOfGodController;
  late TextEditingController applicationInLifeController;

  FocusNode readingBookFocusNode = FocusNode();
  FocusNode verseContentFocusNode = FocusNode();
  FocusNode messageOfGodFocusNode = FocusNode();
  FocusNode applicationInLifeFocusNode = FocusNode();

  validateInput() {
    showRequiredMessageReadingBook = readingBookController.text.isEmpty;
    showRequiredMessageVerseContent = verseContentController.text.isEmpty;
    showRequiredMessageMessageOfGod = messageOfGodController.text.isEmpty;
    showRequiredMessageApplicationInLife =
        applicationInLifeController.text.isEmpty;
    notifyListeners();
  }

  void onSubmit(Map<String, dynamic> body, BuildContext context, String token) {
    validateInput();
    if (!showRequiredMessageReadingBook &&
        !showRequiredMessageVerseContent &&
        !showRequiredMessageMessageOfGod &&
        !showRequiredMessageApplicationInLife) {
      //SUCCESS
      _getWpdaUsecase.createWpda(body, context, token);
    }
    notifyListeners();
  }

  void editWpda(Map<String, dynamic> body, BuildContext context, String token,
      String id) {
    validateInput();
    if (!showRequiredMessageReadingBook &&
        !showRequiredMessageVerseContent &&
        !showRequiredMessageMessageOfGod &&
        !showRequiredMessageApplicationInLife) {
      //SUCCESS
      _getWpdaUsecase.editWpda(body, context, token, id);
    }
    notifyListeners();
  }

  void deleteWpda(
    BuildContext context,
    String id,
    String token,
  ) async {
    await _getWpdaUsecase.deleteWpda(
      context,
      token,
      id,
    );
    Future.delayed(Duration(seconds: 2), () {
      notifyListeners();
    });
  }
}
