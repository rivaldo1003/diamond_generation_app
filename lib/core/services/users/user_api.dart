import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/monthly_data_wpda.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/bottom_navigation_page.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/forget_password/data/controller.dart';
import 'package:diamond_generation_app/features/forget_password/presentation/email_has_been_sent_screen.dart';
import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_register.dart';
import 'package:diamond_generation_app/features/login/presentation/login.dart';
import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/features/register_form/presentation/register_form.dart';
import 'package:diamond_generation_app/features/verified_email/presentation/verify_email_screen.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  final String urlApi;

  UserApi({
    required this.urlApi,
  });

  Future<List<User>> getUser(String urlApi) async {
    final url = Uri.parse(urlApi);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      final users = jsonResponse.map((json) {
        return User.fromJson(json);
      }).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future verifyUser(
      BuildContext context, Map<String, dynamic> body, String token) async {
    final response = await http.post(
      Uri.parse(ApiConstants.verifyUserUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('Connect API verify user');
    } else {
      throw Exception('Failed to verify user');
    }
  }

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

  Future<void> loginUser(
      Map<String, dynamic> body, BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final url = Uri.parse(ApiConstants.loginUrl);

    // Tampilkan pemberitahuan loading
    showDialog(
        barrierDismissible: false,
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
              'Login gagal. Tidak ada koneksi internet.',
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

      await http.post(
        url,
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      ).then((response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          print('RESPONSE : ${data}');
          if (data['success']) {
            Map<String, dynamic> userData = json.decode(response.body)['user'];
            if (userData['profile'] != null) {
              Map<String, dynamic> profile = userData['profile'];
              loginProvider.saveBirthDate(profile['birth_date']);
              loginProvider.saveGender(profile['gender']);
            }

            loginProvider.saveFullName(userData['full_name']);
            loginProvider.saveToken(data['token']);
            loginProvider.saveRole(userData['role']);
            loginProvider.saveUserId(userData['id'].toString());
            loginProvider
                .saveProfileCompleted(userData['profile_completed'].toString());
            print('DATA : $data');
            print('Token : ${data['token']}');

            getDeviceToken(context).then((value) {
              String? deviceToken = value;
              saveSubsriptionId(
                context,
                {
                  'device_token': deviceToken,
                },
                userData['id'].toString(),
                data['token'],
              );
            });

            if (data['role'] == 'admin') {
              // showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) {
              //       return Center(
              //         child: CoolLoading(),
              //       );
              //     });
              Future.delayed(Duration(seconds: 2), () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BottomNavigationPage();
                  }),
                  (route) => false,
                ).then((value) {
                  Future.delayed(Duration(seconds: 5), () {
                    TextFieldControllerLogin.emailController.text = '';
                    TextFieldControllerLogin.passwordController.text = '';
                  });
                });

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
            } else {
              // showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) {
              //       return Center(
              //         child: CoolLoading(),
              //       );
              //     });
              Future.delayed(Duration(seconds: 2), () {
                if (userData['verified'] == 0) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return VerifyEmailScreen(
                        email: userData['email'],
                        verified: userData['verified'],
                      );
                    }),
                    (route) => false,
                  );
                } else {
                  if (userData['profile_completed'] == 0) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return RegisterForm();
                      }),
                      (route) => false,
                    );
                    SnackBarWidget.showSnackBar(
                      context: context,
                      message:
                          'Profil Anda tidak lengkap. Lengkapi profil Anda.',
                      textColor: MyColor.whiteColor,
                      bgColor: MyColor.colorLightBlue,
                    );
                  } else {
                    if (userData['verified'] == 0) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return VerifyEmailScreen(
                            email: userData['email'],
                            verified: userData['verified'],
                          );
                        }),
                        (route) => false,
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return BottomNavigationPage();
                        }),
                        (route) => false,
                      );
                    }

                    // SnackBarWidget.showSnackBar(
                    //   context: context,
                    //   message: data['message'],
                    //   textColor: MyColor.whiteColor,
                    //   bgColor: MyColor.colorGreen,
                    // );
                  }
                }
              });
              TextFieldControllerLogin.emailController.text = '';
              TextFieldControllerLogin.passwordController.text = '';
            }
          } else {
            // showDialog(
            //     barrierDismissible: false,
            //     context: context,
            //     builder: (context) {
            //       return Center(
            //         child: CoolLoading(),
            //       );
            //     });
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);
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
              // Navigator.pop(context);
            });
          }
        } else {
          final data = json.decode(response.body);
          // showDialog(
          //     barrierDismissible: false,
          //     context: context,
          //     builder: (context) {
          //       return Center(
          //         child: CoolLoading(),
          //       );
          //     });
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
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

  Future<String> getDeviceToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceToken =
        prefs.getString(SharedPreferencesManager.keyDeviceToken);
    print('Device Token from SP : $deviceToken');
    return deviceToken ?? '';
  }

  Future<void> saveSubsriptionId(
    BuildContext context,
    Map<String, dynamic> body,
    String id,
    String token,
  ) async {
    final url = Uri.parse('${ApiConstants.saveSubsriptionId}/$id');
    final response = await http.post(url, body: json.encode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print('Success sub id user');
    } else {
      throw Exception('Failed to subscription id user');
    }
  }

  Future<void> registerUser(
      Map<String, dynamic> body, BuildContext context) async {
    final headers = {
      "Content-Type": "application/json",
    };

    // Tampilkan pemberitahuan loading
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: CoolLoading(),
          );
        });

    checkInternetConnection().then(
      (isConnected) async {
        if (!isConnected) {
          // Tidak ada koneksi internet setelah jeda, tampilkan notifikasi gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorRed,
              content: Text(
                'Registrasi gagal. Tidak ada koneksi internet.',
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
            .post(
          Uri.parse(ApiConstants.registerUrl),
          headers: headers,
          body: json.encode(body),
        )
            .then((response) {
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            print('DATA REGISTER :${data}');
            if (data['success']) {
              // showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) {
              //       return Center(
              //         child: CoolLoading(),
              //       );
              //     });
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Login();
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
              TextFieldControllerRegister.fullNameController.text = '';
              TextFieldControllerRegister.emailController.text = '';
              TextFieldControllerRegister.passwordController.text = '';
            } else {
              // showDialog(
              //     barrierDismissible: false,
              //     context: context,
              //     builder: (context) {
              //       return Center(
              //         child: CoolLoading(),
              //       );
              //     });
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: MyColor.colorRed,
                    content: Text(
                      '${data['message']}',
                      style: MyFonts.customTextStyle(
                          14, FontWeight.w500, MyColor.whiteColor),
                    ),
                  ),
                );
              });
            }
          }
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
      },
    );
  }

  Future<void> submitDataUser(
    Map<String, dynamic> body,
    BuildContext context,
    String token,
    String id,
  ) async {
    final registerFormProvider =
        Provider.of<RegisterFormProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': "Bearer $token",
    };
    final response = await http.post(
      Uri.parse(ApiConstants.submitDataUserUrl + '/$id'),
      body: json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        loginProvider
            .saveProfileCompleted(data['profile_completed'].toString());
        loginProvider.saveGender(data['gender'].toString());

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CoolLoading(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return BottomNavigationPage();
            }),
            (route) => false,
          );
          registerFormProvider.fullNameController.text = '';
          registerFormProvider.addressController.text = '';
          registerFormProvider.phoneNumberController.text = '';
          registerFormProvider.placeOfBirthController.text = '';
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
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CoolLoading(),
              );
            });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${data['message']}',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.greyText,
              ),
            ),
          ),
        );
      }
      print('Update profile API success');
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(int userId, String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + '/users/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result;
      } else {
        throw Exception(
            'Failed to load data user profile. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<AllUsers>> getAllUsers(String token) async {
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
      List<AllUsers> usersList =
          jsonData.map((data) => AllUsers.fromJson(data)).toList();
      return usersList;
    } else {
      throw Exception('Failed to load users data');
    }
  }

  Future<void> approveUser(
      BuildContext context, String token, String id) async {
    try {
      final viewAllDataUserProvider =
          Provider.of<SearchUserProvider>(context, listen: false);

      final headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      };
      final response = await http.put(
        Uri.parse(ApiConstants.approveUserUrl + '/$id'),
        headers: headers,
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
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to approve user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> deleteUser(
    String userId,
    BuildContext context,
    String token,
  ) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.deleteUserUrl + '/$userId'),
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
      throw Exception('Failed to delete user');
    }
  }

  Future<void> updateProfile(
    BuildContext context,
    String userId,
    String token,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse(ApiConstants.updateProfile + '/$userId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        print(response.body);
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
      throw Exception('Gagal update user profile');
    }
  }

  Future<Map<String, dynamic>> getTotalNewUsers(String token) async {
    final url = Uri.parse(ApiConstants.getTotalNewUsers);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data new users');
    }
  }

  Future<ApiResponse> getMonthlyDataForAllUsers(String token) async {
    final url = Uri.parse(ApiConstants.getMonthlyDataForAllUsers);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print('Status Respon: ${response.statusCode}');
    print('Body Respon: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Gagal mendapatkan data: ${response.body ?? "No data"}');
    }
  }

  Future<Map<String, dynamic>> userGenderTotal(String token) async {
    try {
      final response =
          await http.get(Uri.parse(ApiConstants.userGenderTotal), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return data; // Sesuaikan dengan struktur respons API Anda
      } else {
        throw Exception(
            'Failed to load data user total gender. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e; // Rethrow exception untuk menangkapnya di FutureBuilder
    }
  }

  Future<void> updateFullName(BuildContext context, Map<String, dynamic> body,
      String userId, String token) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/users/$userId/update-full-name'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body), // Mengonversi body ke format JSON
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        print(response.body);
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
      throw Exception('Failed to update full name');
    }
  }

  Future<void> logout(BuildContext context, String token) async {
    final url = Uri.parse(ApiConstants.logoutUrl);
    final response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        print(response.body);
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return Login();
            }),
            (route) => false,
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     backgroundColor: MyColor.colorGreen,
          //     content: Text(
          //       '${data['message']}',
          //       style: MyFonts.customTextStyle(
          //         14,
          //         FontWeight.w500,
          //         MyColor.whiteColor,
          //       ),
          //     ),
          //   ),
          // );
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
      throw Exception('Logut API Error');
    }
  }

  Future<void> verifyEmail(
    BuildContext context,
    String token,
    String email,
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.verifyEmail}/$email');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Verify API connect successfully');
        // Tambahkan logika lain yang diperlukan setelah berhasil verifikasi email
      } else {
        throw Exception('Failed to connect API verification email');
      }
    } catch (error) {
      print('Error: $error');
      // Tambahkan penanganan kesalahan sesuai kebutuhan Anda, misalnya menampilkan dialog kesalahan kepada pengguna
    }
  }

  Future<void> forgetPassword(
      BuildContext context, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.forgetPassword}');
    final response = await http.post(url, body: jsonEncode(body), headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CoolLoading();
        },
      );
      if (data['success']) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EmailHasBeenSentScreen(
              email: forgetPasswordEmail.text,
            );
          }));
        });
      } else {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
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
      }
    } else {
      throw Exception('Failed connect to forget password API.');
    }
  }

  Future<void> changeRole(
    BuildContext context,
    Map<String, dynamic> body,
    String id,
    String token,
  ) async {
    final url =
        Uri.parse("https://gsjasungaikehidupan.com/api/change-role/$id");
    final headers = {
      "Content-Type": "application/json",
      'Authorization': "Bearer $token",
    };

    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: headers,
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
            Navigator.pop(context); // Pop loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${data['message']}'),
              ),
            );
            Navigator.pop(context); // Pop confirmation dialog
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${data['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
          ),
        );
      }
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }
}
