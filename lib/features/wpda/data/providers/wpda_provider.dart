import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
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

  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  void updateComments(List<Comment> newComments) {
    _comments = newComments;
    notifyListeners();
  }

  List<WPDA> wpdas = [];
  var history;
  List<HistoryWpda> historyWpda = [];

  Future refreshAllUsers(String token) async {
    try {
      List<WPDA> fetchedWpdas = await _getWpdaUsecase.getAllWpda(token);
      wpdas.clear();
      wpdas.addAll(fetchedWpdas);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error fetching WPDA: $e");
    }
  }

  Future refreshWpdaHistory(String userId, String token) async {
    // try {
    //   History history = await _getWpdaUsecase.getAllWpdaByUserID(userId, token);
    //   // Jika historyWpda adalah List<HistoryWpda>, perbarui sesuai kebutuhan
    //   // Misalnya, jika history memiliki list HistoryWpda yang ingin Anda tambahkan ke historyWpda:
    //   historyWpda.clear();
    //   historyWpda.addAll(history.data);
    //   notifyListeners();
    // } catch (e) {
    //   // Handle error
    //   print("Error fetching WPDA history: $e");
    // }
    Future.delayed(Duration(seconds: 0), () async {
      await _getWpdaUsecase.getAllWpdaByUserID(userId, token);
      notifyListeners();
    });
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
