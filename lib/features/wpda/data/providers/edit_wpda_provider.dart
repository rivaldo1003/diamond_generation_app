import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:flutter/material.dart';

class EditWpdaProvider with ChangeNotifier {
  final GetWpdaUsecase _getWpdaUsecase;

  EditWpdaProvider({required GetWpdaUsecase getWpdaUsecase})
      : _getWpdaUsecase = getWpdaUsecase;

  bool showRequiredMessageReadingBook = false;
  bool showRequiredMessageVerseContent = false;
  bool showRequiredMessageMessageOfGod = false;
  bool showRequiredMessageApplicationInLife = false;

  TextEditingController readingBookController = TextEditingController();
  TextEditingController verseContentController = TextEditingController();
  TextEditingController messageOfGodController = TextEditingController();
  TextEditingController applicationInLifeController = TextEditingController();

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

  // Fungsi untuk mengupdate nilai TextEditingController dari luar
  void updateControllerValues({
    required String ReadingBook,
    required String VerseContent,
    required String MessageOfGod,
    required String ApplicationInLife,
  }) {
    readingBookController.text = ReadingBook;
    verseContentController.text = VerseContent;
    messageOfGodController.text = MessageOfGod;
    applicationInLifeController.text = ApplicationInLife;
    notifyListeners();
  }

  void onSubmit(Map<String, dynamic> body, BuildContext context, String token,
      String id) async {
    validateInput();
    if (!showRequiredMessageReadingBook &&
        !showRequiredMessageVerseContent &&
        !showRequiredMessageMessageOfGod &&
        !showRequiredMessageApplicationInLife) {
      // Eksekusi fungsi editWpda
      await _getWpdaUsecase.editWpda(body, context, token, id);

      // Setelah fungsi selesai dieksekusi, perbarui nilai TextEditingController
      updateControllerValues(
        ReadingBook: body['reading_book'],
        VerseContent: body['verse_content'],
        MessageOfGod: body['message_of_god'],
        ApplicationInLife: body['application_in_life'],
      );
    }
  }

  List<String> newSelectedItems = [];
}
