import 'dart:convert';

import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileAPI {
  Future<void> uploadProfilePicture(
      String imagePath, int userId, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/users/$userId/upload-profile-picture'),
    );

    request.fields['user_id'] = userId.toString();

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath('profile_picture', imagePath),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Upload berhasil');
      } else {
        print('Gagal upload. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteProfilePicture(
      BuildContext context, int userId, String token) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/users/$userId/delete-profile-picture');
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: CoolLoading(),
            );
          },
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
          Navigator.pop(context);
        });
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: CoolLoading(),
            );
          },
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
          Navigator.pop(context);
        });
      }
    } else {
      throw Exception('Gagal hapus profil gambar');
    }
  }
}
