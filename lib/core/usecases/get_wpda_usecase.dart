import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/repositories/wpda_repository.dart';
import 'package:flutter/material.dart';

class GetWpdaUsecase {
  final WpdaRepository wpdaRepository;

  GetWpdaUsecase({
    required this.wpdaRepository,
  });
  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context) async {
    await wpdaRepository.createWpda(body, context);
  }

  Future<List<WPDA>> getAllWpda() async {
    return await wpdaRepository.getAllWpda();
  }

  Future<void> editWpda(Map<String, dynamic> body, BuildContext context) async {
    await wpdaRepository.editWpda(body, context);
  }

  Future<void> deleteWpda(
      Map<String, dynamic> body, BuildContext context) async {
    await wpdaRepository.deleteWpda(body, context);
  }
}
