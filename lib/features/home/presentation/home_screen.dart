import 'dart:convert';
import 'dart:io';

import 'package:diamond_generation_app/core/services/profile/profile_api.dart';
import 'package:diamond_generation_app/features/detail_community/presentation/detail_community.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/view_all_data_users/presentation/view_all_data.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/card_community.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_card_wpda.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  final keyImageProfile = "image_profile";

  String? userId;
  String? token;

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(SharedPreferencesManager.keyUserId);
    });
    return userId;
  }

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
    });
  }

  Future loading() async {
    Future.delayed(Duration(seconds: 2), () {
      return PlaceholderCardWpda();
    });
  }

  @override
  void initState() {
    loading().then((value) => print('Dijalankan'));
    getUserId().then((userId) {
      if (userId != null) {
        loadImage().then((value) {
          setState(() {});
        });
      }
    });
    getToken();
    super.initState();
  }

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString(keyImageProfile);
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _image = File(imagePath);
        print('INI FILE IMAGE PATH :$imagePath');
      });
    }

    if (userId != null && _image == null) {
      await fetchProfilePicture(int.parse(userId!), token!);
    } else {
      print('Halo');
      // Tindakan yang sesuai jika userId null
    }
  }

  Future<void> fetchProfilePicture(int userId, String token) async {
    try {
      var response = await http.get(
        Uri.parse(
          'http://192.168.110.85/diamond-generation-service/public/api/users/$userId/profile-picture',
        ),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var profilePictureUrl = jsonResponse['profile_picture_url'];
        await downloadAndSaveImage(profilePictureUrl, userId);
      } else {
        print('Gagal mengambil gambar. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> saveImage(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyImageProfile);
    prefs.setString(keyImageProfile, imageFile.path);
  }

  Future<void> downloadAndSaveImage(String imageUrl, int userId) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final appDir = await getApplicationDocumentsDirectory();
      final extension =
          imageUrl.split('.').last; // Ambil ekstensi gambar dari URL
      final localPath = appDir.path + '/user_$userId.$extension';

      final file = File(localPath);
      await file.writeAsBytes(response.bodyBytes);

      print('Gambar berhasil diunduh dan disimpan di: $localPath');
      _image = File(localPath);
      saveImage(_image!).then((value) {
        print('Berhasil di download dari server dan di save di SP');
      });
    } else {
      print('Gagal mengunduh gambar. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Beranda'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<LoginProvider>(builder: (context, value, _) {
                            if (value.fullName == null) {
                              value.loadFullName();
                              return CircularProgressIndicator();
                            } else {
                              List<String> dataFullName =
                                  value.fullName!.split(' ');
                              String firstName = dataFullName.isNotEmpty
                                  ? dataFullName[0]
                                  : '';
                              return Text(
                                'Hello, ${firstName}👋',
                                style: MyFonts.brownText(
                                  20,
                                  FontWeight.bold,
                                ),
                              );
                            }
                          }),
                          Text(
                            'Ayo, jadikan semua bangsa muridmu',
                            style: MyFonts.brownText(
                              14,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    (_image == null)
                        ? Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Warna border putih
                                width: 2.0, // Lebar border
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/profile_empty.jpg',
                              ),
                            ),
                          )
                        : Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Warna border putih
                                width: 2.0, // Lebar border
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: FileImage(_image!),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  hintText: 'Temukan komunitas anda...',
                  obscureText: false,
                  controller:
                      TextFieldControllerLogin.searchCommunityController,
                  suffixIcon: Icon(
                    Icons.search,
                    color: MyColor.greyText,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Image.asset('assets/images/title.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ViewAllData();
                        }));
                      },
                      child: Text(
                        'Lihat semua\n pengguna',
                        style: MyFonts.customTextStyle(
                          12,
                          FontWeight.bold,
                          MyColor.colorLightBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              children: [
                CardCommunity(
                  title: 'New Creation 1',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailCommunity(
                        urlApi: ApiConstants.newCreation1Url,
                        title: 'New Creation 1',
                      );
                    }));
                  },
                ),
                SizedBox(height: 12),
                CardCommunity(
                  title: 'New Creation 2',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailCommunity(
                        urlApi: ApiConstants.newCreation2Url,
                        title: 'New Creation 2',
                      );
                    }));
                  },
                ),
                SizedBox(height: 12),
                CardCommunity(
                  title: 'Light',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailCommunity(
                        urlApi: ApiConstants.lightUrl,
                        title: 'Light',
                      );
                    }));
                  },
                ),
                SizedBox(height: 12),
                CardCommunity(
                  title: 'Grow',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailCommunity(
                        urlApi: ApiConstants.lightUrl,
                        title: 'Grow',
                      );
                    }));
                  },
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
