import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:flutter/material.dart';

class EditWpdaProvider with ChangeNotifier {
  final GetWpdaUsecase _getWpdaUsecase;

  EditWpdaProvider({required GetWpdaUsecase getWpdaUsecase})
      : _getWpdaUsecase = getWpdaUsecase;

  bool showRequiredMessageKitabBacaan = false;
  bool showRequiredMessageIsiKitab = false;
  bool showRequiredMessagePesanTuhan = false;
  bool showRequiredMessageAplikasiKehidupan = false;

  TextEditingController kitabBacaanController = TextEditingController();
  TextEditingController isiKitabController = TextEditingController();
  TextEditingController pesanTuhanController = TextEditingController();
  TextEditingController aplikasiKehidupanController = TextEditingController();

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

  // Fungsi untuk mengupdate nilai TextEditingController dari luar
  void updateControllerValues({
    required String kitabBacaan,
    required String isiKitab,
    required String pesanTuhan,
    required String aplikasiKehidupan,
  }) {
    kitabBacaanController.text = kitabBacaan;
    isiKitabController.text = isiKitab;
    pesanTuhanController.text = pesanTuhan;
    aplikasiKehidupanController.text = aplikasiKehidupan;
    notifyListeners();
  }

  void onSubmit(Map<String, dynamic> body, BuildContext context) async {
    validateInput();
    if (!showRequiredMessageKitabBacaan &&
        !showRequiredMessageIsiKitab &&
        !showRequiredMessagePesanTuhan &&
        !showRequiredMessageAplikasiKehidupan) {
      // Eksekusi fungsi editWpda
      await _getWpdaUsecase.editWpda(body, context);

      // Setelah fungsi selesai dieksekusi, perbarui nilai TextEditingController
      updateControllerValues(
        kitabBacaan: body['kitab_bacaan'],
        isiKitab: body['isi_kitab'],
        pesanTuhan: body['pesan_tuhan'],
        aplikasiKehidupan: body['aplikasi_kehidupan'],
      );
    }
  }
}
