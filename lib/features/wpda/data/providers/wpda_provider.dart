import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class WpdaProvider with ChangeNotifier {
  final GetWpdaUsecase _getWpdaUsecase;

  WpdaProvider({required GetWpdaUsecase getWpdaUsecase})
      : _getWpdaUsecase = getWpdaUsecase,
        kitabBacaanController = TextEditingController(),
        isiKitabController = TextEditingController(),
        pesanTuhanController = TextEditingController(),
        aplikasiKehidupanController = TextEditingController();

  void createWpda(Map<String, dynamic> body, BuildContext context) async {
    await _getWpdaUsecase.createWpda(body, context);
    notifyListeners();
  }

  @override
  void dispose() {
    aplikasiKehidupanController.dispose();
    isiKitabController.dispose();
    kitabBacaanController.dispose();
    pesanTuhanController.dispose();
    super.dispose();
  }

  Future refreshApp(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColor.colorGreen,
          content: Text(
            'Berhasil diperbarui',
            style: MyFonts.customTextStyle(
              14,
              FontWeight.w500,
              MyColor.whiteColor,
            ),
          ),
        ),
      );
    });
  }

  List<WPDA> wpdas = [];
  var history;
  List<HistoryWpda> historyWpda = [];

  Future refreshAllUsers() async {
    wpdas = await _getWpdaUsecase.getAllWpda();
    Future.delayed(Duration(seconds: 2), () {
      notifyListeners();
    });
  }

  Future refreshWpdaHistory(String userId) async {
    await _getWpdaUsecase.getAllWpdaByUserID(userId);
    notifyListeners();
  }

  bool showRequiredMessageKitabBacaan = false;
  bool showRequiredMessageIsiKitab = false;
  bool showRequiredMessagePesanTuhan = false;
  bool showRequiredMessageAplikasiKehidupan = false;

  late TextEditingController kitabBacaanController;
  late TextEditingController isiKitabController;
  late TextEditingController pesanTuhanController;
  late TextEditingController aplikasiKehidupanController;

  FocusNode kitabBacaanFocusNode = FocusNode();
  FocusNode isiKitabFocusNode = FocusNode();
  FocusNode pesanTuhanFocusNode = FocusNode();
  FocusNode aplikasiKehidupanFocusNode = FocusNode();

  validateInput() {
    showRequiredMessageKitabBacaan = kitabBacaanController.text.isEmpty;
    showRequiredMessageIsiKitab = isiKitabController.text.isEmpty;
    showRequiredMessagePesanTuhan = pesanTuhanController.text.isEmpty;
    showRequiredMessageAplikasiKehidupan =
        aplikasiKehidupanController.text.isEmpty;
    notifyListeners();
  }

  void onSubmit(Map<String, dynamic> body, BuildContext context) {
    validateInput();
    if (!showRequiredMessageKitabBacaan &&
        !showRequiredMessageIsiKitab &&
        !showRequiredMessagePesanTuhan &&
        !showRequiredMessageAplikasiKehidupan) {
      //SUCCESS
      _getWpdaUsecase.createWpda(body, context);
    }
    notifyListeners();
  }

  void editWpda(Map<String, dynamic> body, BuildContext context) {
    validateInput();
    if (!showRequiredMessageKitabBacaan &&
        !showRequiredMessageIsiKitab &&
        !showRequiredMessagePesanTuhan &&
        !showRequiredMessageAplikasiKehidupan) {
      //SUCCESS
      _getWpdaUsecase.editWpda(body, context);
    }
    notifyListeners();
  }

  void deleteWpda(Map<String, dynamic> body, BuildContext context) async {
    await _getWpdaUsecase.deleteWpda(body, context);
    Future.delayed(Duration(seconds: 2), () {
      notifyListeners();
    });
  }
}
