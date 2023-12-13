import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/repositories/wpda_repository.dart';
import 'package:flutter/material.dart';

class GetWpdaUsecase {
  final WpdaRepository wpdaRepository;

  GetWpdaUsecase({
    required this.wpdaRepository,
  });
  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context, String token) async {
    await wpdaRepository.createWpda(body, context, token);
  }

  Future<List<WPDA>> getAllWpda(String token) async {
    return await wpdaRepository.getAllWpda(token);
  }

  Future<void> editWpda(Map<String, dynamic> body, BuildContext context,
      String token, String id) async {
    await wpdaRepository.editWpda(body, context, token, id);
  }

  Future<void> deleteWpda(BuildContext context, String token, String id) async {
    await wpdaRepository.deleteWpda(context, token, id);
  }

  Future<History> getAllWpdaByUserID(String userId, String token) async {
    return await wpdaRepository.getAllWpdaByUserId(userId, token);
  }
}
