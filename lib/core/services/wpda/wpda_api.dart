import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/core/models/monthly_report.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/bottom_navigation_page.dart';
import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/bible_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/edit_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class WpdaApi {
  final String urlApi;

  WpdaApi({
    required this.urlApi,
  });

  // Fungsi untuk memeriksa koneksi internet menggunakan http
  Future<bool> checkInternetConnection() async {
    try {
      final response = await http
          .head(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } on TimeoutException catch (_) {
      return false; // Timeout, koneksi internet lambat atau tidak stabil
    } on SocketException catch (_) {
      return false; // Tidak ada koneksi internet
    } catch (e) {
      return false; // Kesalahan lain dalam memeriksa koneksi
    }
  }

  Future<void> _saveMessageLocally(Map<String, dynamic> message) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/wpda.json');

    try {
      List<Map<String, dynamic>> messages = [];
      if (await file.exists()) {
        final contents = await file.readAsString();
        messages = List<Map<String, dynamic>>.from(json.decode(contents));
      }
      messages.add(message);
      await file.writeAsString(json.encode(messages));
      print('Messages $message');
    } catch (error) {
      print('Error saving message locally: $error');
    }
  }

  Future<void> _sendWpdaToServer(
      List<Map<String, dynamic>> pendingMessages, String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    for (final message in pendingMessages) {
      try {
        final response = await http.post(
          Uri.parse(ApiConstants.createWpdaUrl),
          headers: headers,
          body: json.encode(message),
        );

        if (response.statusCode == 200) {
          print('WPDA successfully sent to server');
          // Hapus pesan dari daftar pending jika berhasil dikirim
          pendingMessages.remove(message);
        } else {
          print('Failed to send WPDA to server: ${response.statusCode}');
        }
      } catch (error) {
        print('Error sending WPDA to server: $error');
      }
    }
  }

  List<Map<String, dynamic>> pendingMessages = [];

// Menambahkan pesan ke daftar pendingMessages
  void addPendingMessage(Map<String, dynamic> message) {
    pendingMessages.add(message);
  }

// Menghapus pesan dari daftar pendingMessages setelah berhasil dikirim
  void removePendingMessage(Map<String, dynamic> message) {
    pendingMessages.remove(message);
  }

// Kirim pesan tertunda ke server
  Future<void> sendPendingMessages(String token) async {
    for (final message in pendingMessages) {
      try {
        // Kirim pesan ke server
        await _sendWpdaToServer(pendingMessages, token);
        // Hapus pesan dari daftar pendingMessages setelah berhasil dikirim
        removePendingMessage(message);
      } catch (error) {
        // Tangani kesalahan jika pesan gagal dikirim
        print('Error sending pending message: $error');
      }
    }
  }

  Future<void> notificationOneSignal(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse(ApiConstants.notification);
      final response = await http.post(url, body: json.encode(body), headers: {
        'Authorization': 'Basic ${ApiConstants.ONE_SIGNAL_REST_API_KEY}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('Status code : ${response.statusCode}');
        print('Success to send notif');
      } else {
        print('Failed to send notif. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
      throw Exception('Failed to send notif: $e');
    }
  }

  Future<List<String>> getAllDeviceTokens(String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(
      Uri.parse(ApiConstants.getAllUser),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body)['users_data'];

      // Ambil device_token dari setiap user_data
      List<String> deviceTokens = [];
      for (var userData in jsonData) {
        String? deviceToken =
            userData['device_token']; // Tambahkan tanda tanya (?)
        if (deviceToken != null) {
          deviceTokens.add(deviceToken);
        }
      }

      print('All device tokens: $deviceTokens');
      return deviceTokens;
    } else {
      throw Exception('Failed to load users data');
    }
  }

  Future<void> createWpda(
    Map<String, dynamic> body,
    BuildContext context,
    String token,
  ) async {
    final wpdaProvider = Provider.of<WpdaProvider>(context, listen: false);
    final bibleProvider = Provider.of<BibleProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    await _saveMessageLocally(body);

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CoolLoading(),
        );
      },
    );

    int retries = 0;
    const maxRetries = 3;
    const initialDelay = Duration(seconds: 2);

    while (retries < maxRetries) {
      try {
        final isConnected = await checkInternetConnection();
        if (!isConnected) {
          Navigator.pop(context);
          // Tidak ada koneksi internet setelah jeda, tampilkan notifikasi gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorRed,
              content: Text(
                'Gagal mengirim WPDA. Periksa koneksi internet anda',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
          return;
        }

        final response = await http.post(
          Uri.parse(ApiConstants.createWpdaUrl),
          headers: headers,
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print('Success send WPDA');
          _showSuccessSnackBar(context, wpdaProvider, bibleProvider, data);
          return;
        } else if (response.statusCode == 400) {
          final Map<String, dynamic> data = json.decode(response.body);
          _handleError(
            context,
            wpdaProvider,
            data['message'],
            MyColor.colorRed,
          );
          return;
        } else if (response.statusCode == 429) {
          // Status code 429: Terlalu banyak permintaan, tunggu dan coba lagi
          await Future.delayed(
            initialDelay * (retries + 1), // Exponential backoff
          );
          retries++;
        } else {
          _handleError(
            context,
            wpdaProvider,
            'Gagal membuat WPDA',
            MyColor.colorRed,
          );
          return;
        }
      } catch (error) {
        // Tangani kesalahan apapun yang mungkin terjadi saat mengirim permintaan HTTP
        print('Error: $error');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColor.colorRed,
            content: Text(
              'Gagal: Terjadi kesalahan.',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.whiteColor,
              ),
            ),
            action: SnackBarAction(
              label: 'Coba Lagi',
              onPressed: () {
                Navigator.pop(context); // Tutup snackbar
                createWpda(body, context, token); // Coba kirim lagi
              },
            ),
          ),
        );
        return;
      }
    }

    // Jika semua upaya gagal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: MyColor.colorRed,
        content: Text(
          'Gagal: Server terlalu banyak pengunjung. Harap coba lagi dalam 30 detik.',
          style: MyFonts.customTextStyle(
            14,
            FontWeight.w500,
            MyColor.whiteColor,
          ),
        ),
      ),
    );
    Navigator.pop(context);
  }

  void _showSuccessSnackBar(BuildContext context, WpdaProvider wpdaProvider,
      BibleProvider bibleProvider, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString(SharedPreferencesManager.keyRole);

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return BottomNavigationPage(
            index: (role == "admin" || role == 'super_admin') ? 1 : 0,
          );
        }),
        (route) => false,
      );

      wpdaProvider.readingBookController.text = '';
      wpdaProvider.verseContentController.text = '';
      wpdaProvider.messageOfGodController.text = '';
      wpdaProvider.applicationInLifeController.text = '';
      bibleProvider.startVerseControllerAdd.text = '';
      bibleProvider.endVerseControllerAdd.text = '';

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
    });
  }

  void _handleError(BuildContext context, WpdaProvider wpdaProvider,
      String errorMessage, Color snackBarColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString(SharedPreferencesManager.keyRole);

    Navigator.pop(context); // Tutup dialog pemberitahuan loading

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CoolLoading(),
        );
      },
    );

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context); // Tutup dialog pemberitahuan loading
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return BottomNavigationPage(
            index: (role == "admin" || role == 'super_admin') ? 1 : 0,
          );
        }),
        (route) => false,
      );

      wpdaProvider.readingBookController.text = '';
      wpdaProvider.verseContentController.text = '';
      wpdaProvider.messageOfGodController.text = '';
      wpdaProvider.applicationInLifeController.text = '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: snackBarColor,
          content: Text(
            errorMessage,
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

  Future<List<WPDA>> getAllWpda(String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    String imageUrlWithTimestamp =
        "${ApiConstants.getAllWpdaUrl}?timestamp=${DateTime.now().millisecondsSinceEpoch}";

    int retries = 0;
    const maxRetries = 3;
    const initialDelay = Duration(seconds: 3);

    while (retries < maxRetries) {
      try {
        final response = await http.get(
          Uri.parse(imageUrlWithTimestamp),
          headers: headers,
        );

        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = json.decode(response.body)['data'];
          return jsonResponse.map((json) {
            return WPDA.fromJson(json);
          }).toList();
        } else if (response.statusCode == 429) {
          // Status code 429: Terlalu banyak permintaan, coba lagi setelah penundaan
          await Future.delayed(
              initialDelay * (retries + 1)); // Exponential backoff
          retries++;
        } else {
          print("Status code: ${response.statusCode}");
          throw Exception('Failed to get all wpda data');
        }
      } catch (error) {
        print("Error: $error");
        throw Exception('Failed to get all wpda data');
      }
    }

    // Jika semua upaya gagal
    throw Exception('Failed to get all wpda data after $maxRetries retries');
  }

  Future<void> editWpda(Map<String, dynamic> body, BuildContext context,
      String token, String id) async {
    final editWpdaProvider =
        Provider.of<EditWpdaProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    // Tampilkan pemberitahuan loading
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CoolLoading(),
          );
        });

    checkInternetConnection().then((isConnected) async {
      if (!isConnected) {
        // Tidak ada koneksi internet setelah jeda, tampilkan notifikasi gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColor.colorRed,
            content: Text(
              'WPDA gagal diperbarui. Periksa koneksi internet anda.',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.whiteColor,
              ),
            ),
          ),
        );
        return Navigator.pop(context);
      }
      await http
          .put(
        Uri.parse(ApiConstants.editWpdaUrl + '/$id'),
        headers: headers,
        body: json.encode(body),
      )
          .then((response) async {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? role = prefs.getString(SharedPreferencesManager.keyRole);
          if (data['success']) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return BottomNavigationPage(
                    index: (role == "admin" || role == 'super_admin') ? 1 : 0,
                  );
                }),
                (route) => false,
              );
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
              editWpdaProvider.readingBookController.text = '';
              editWpdaProvider.verseContentController.text = '';
              editWpdaProvider.messageOfGodController.text = '';
              editWpdaProvider.applicationInLifeController.text = '';
            });
          } else {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return BottomNavigationPage(
                    index: (role == "admin" || role == 'super_admin') ? 1 : 0,
                  );
                }),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: MyColor.colorRed,
                  content: Text(
                    'gagal',
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
        } else {
          throw Exception('Gagal edit data WPDA');
        }
      });
    }).catchError((error) {
      // Tangani kesalahan apapun yang mungkin terjadi saat mengirim permintaan HTTP
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColor.colorRed,
          content: Text(
            'Gagal: Terjadi kesalahan.',
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

  Future<void> deleteWpda(
    BuildContext context,
    String id,
    String token,
  ) async {
    var url = Uri.parse(
        '${ApiConstants.baseUrl}/wpda/delete/$id'); // Sesuaikan URL dengan endpoint backend Anda

    try {
      var response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Sesuaikan token dengan token autentikasi Anda
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString(SharedPreferencesManager.keyRole);
        if (data['success']) {
          print(role);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Center(
                  child: CoolLoading(),
                );
              });
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return BottomNavigationPage(
                  index: (role == "admin" || role == 'super_admin') ? 1 : 0,
                );
              }),
              (route) => false,
            );
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
          });
        }
      } else if (response.statusCode == 404) {
        print('WPDA data not found');
      } else if (response.statusCode == 403) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString(SharedPreferencesManager.keyRole);
        final data = json.decode(response.body);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CoolLoading(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return BottomNavigationPage(
                index: (role == "admin" || role == 'super_admin') ? 1 : 0,
              );
            }),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorRed,
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
        });
      } else {
        print('Failed to delete WPDA. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Exception occured while deleting WPDA: $error');
    }
  }

  Future<History> getAllWpdaByUserId(String userId, String token) async {
    final url = Uri.parse('${ApiConstants.historyWpdaUrl}/$userId');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    int retries = 0;
    const maxRetries = 3;
    const initialDelay = Duration(seconds: 2);

    while (retries < maxRetries) {
      try {
        final response = await http.get(
          url,
          headers: headers,
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          return History.fromJson(jsonResponse);
        } else if (response.statusCode == 429) {
          // Status code 429: Terlalu banyak permintaan, coba lagi setelah penundaan
          await Future.delayed(
              initialDelay * (retries + 1)); // Exponential backoff
          retries++;
        } else {
          throw Exception(
              'Failed to load history data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        throw Exception('Failed to load history data: $error');
      }
    }

    // Jika semua upaya gagal
    throw Exception(
        'Failed to load history data: Server terlalu banyak pengunjung. Harap coba lagi dalam 30 detik.');
  }

  Future<MonthlyReport> fetchWpdaByMonth(BuildContext context, String token,
      String userId, int month, int year) async {
    final url = Uri.parse(
      ApiConstants.historyWpdaUrl + '/filter/$userId?month=$month&year=$year',
    );
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return MonthlyReport.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to load history data. Status code: ${response.statusCode}');
    }
  }

  Future<void> likeWpda(int userId, int wpdaId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/like/$userId/$wpdaId');
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('Success connect likeWpda API');
    } else {
      throw Exception('Failed to connect likeWPDA API');
    }
  }

  Future<void> unlikeWpda(int userId, int wpdaId, String token) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/unlike/$userId/$wpdaId');
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    final response = await http.delete(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('Success connect unlikeWpda API');
    } else {
      throw Exception('Failed to connect unlikeWPDA API');
    }
  }

  Future<List<WPDA>> getWpdaObedEdom(String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    String imageUrlWithTimestamp =
        "${ApiConstants.getWpdaObedEdom}?timestamp=${DateTime.now().millisecondsSinceEpoch}";

    int retries = 0;
    const maxRetries = 3;
    const initialDelay = Duration(seconds: 3);

    while (retries < maxRetries) {
      try {
        final response = await http.get(
          Uri.parse(imageUrlWithTimestamp),
          headers: headers,
        );

        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = json.decode(response.body)['data'];
          return jsonResponse.map((json) {
            return WPDA.fromJson(json);
          }).toList();
        } else if (response.statusCode == 429) {
          // Status code 429: Terlalu banyak permintaan, coba lagi setelah penundaan
          await Future.delayed(
              initialDelay * (retries + 1)); // Exponential backoff
          retries++;
        } else {
          print("Status code: ${response.statusCode}");
          throw Exception('Failed to get all wpda data');
        }
      } catch (error) {
        print("Error: $error");
        throw Exception('Failed to get all wpda data');
      }
    }

    // Jika semua upaya gagal
    throw Exception('Failed to get all wpda data after $maxRetries retries');
  }
}
