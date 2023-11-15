import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/services/api_services.dart';
import 'package:flutter/material.dart';

abstract class WpdaRepository {
  Future<void> createWpda(Map<String, dynamic> body, BuildContext context);
  Future<List<WPDA>> getAllWpda();
}

class WpdaRepositoryImpl implements WpdaRepository {
  final ApiService apiService;

  WpdaRepositoryImpl({
    required this.apiService,
  });
  @override
  Future<void> createWpda(
      Map<String, dynamic> body, BuildContext context) async {
    await apiService.createWpda(body, context);
  }

  @override
  Future<List<WPDA>> getAllWpda() async {
    return await apiService.getAllWpda();
  }
}
