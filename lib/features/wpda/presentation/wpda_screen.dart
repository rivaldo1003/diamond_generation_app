import 'dart:convert';
import 'dart:io';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/drop_down_state_model.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/card_wpda.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_card_wpda.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class WPDAScreen extends StatefulWidget {
  AllUsers? users;

  WPDAScreen({super.key, this.users});
  @override
  State<WPDAScreen> createState() => _WPDAScreenState();
}

class _WPDAScreenState extends State<WPDAScreen> {
  Future<bool> checkIfWPDAUploadedTodayForUser(
      String userId, List<WPDA>? data) async {
    var currentDate = DateTime.now();
    var formatDate = DateFormat('yy MMM dd').format(currentDate);

    if (data != null) {
      for (var wpda in data) {
        if (wpda.user_id == userId) {
          var dateUploaded = DateFormat('yy MMM dd').format(DateTime.parse(wpda
              .created_at)); // Sesuaikan format tanggal dengan yang ada di WPDA
          if (dateUploaded == formatDate) {
            return true;
          }
        }
      }
    }
    return false;
  }

  String? token;
  String? userId;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(SharedPreferencesManager.keyUserId);
    });
    return userId;
  }

  File? _image;
  final keyImageProfile = "image_profile";

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString(keyImageProfile);
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _image = File(imagePath);
      });
    } else if (userId != null && _image == null) {
      await fetchProfilePicture(int.parse(userId!), token!);
    }
  }

  Future<void> fetchProfilePicture(int userId, String token) async {
    try {
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/users/$userId/profile-picture'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var profilePictureUrl = jsonResponse['profile_picture'];

        var modifiedUrl = profilePictureUrl.replaceFirst(
            "storage/", "storage/profile_pictures/");

        setState(() {
          // Update state here
        });

        await downloadAndSaveImage(modifiedUrl, userId);
      } else {
        print('Failed to fetch image. Status code: ${response.statusCode}');
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
      final extension = imageUrl.split('.').last;
      final localPath = appDir.path + '/user_$userId.$extension';

      final file = File(localPath);
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        _image = file;
      });

      saveImage(file);
    } else {
      print('Failed to download image. Status code: ${response.statusCode}');
    }
  }

  Future<void> viewAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> allData = prefs.getKeys().fold<Map<String, dynamic>>(
      {},
      (Map<String, dynamic> acc, String key) {
        acc[key] = prefs.get(key);
        return acc;
      },
    );

    print('All SharedPreferences Data: $allData');
  }

  Future loading() async {
    Future.delayed(Duration(seconds: 2), () {
      return PlaceholderCardWpda();
    });
  }

  List<String> _items = [
    'Semua',
    'Obed Edom',
  ];
  String? _valItem;

  @override
  void initState() {
    loading().then((value) => print('Dijalankan'));
    getUserId().then((userId) {
      if (userId != null) {
        loadImage().then((value) {
          loadImage();
          setState(() {});
        });
      }
    });

    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getWpdaUsecase = Provider.of<GetWpdaUsecase>(context);
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    final dropdownStateModel = Provider.of<DropdownStateModel>(context);
    var today = DateTime.now();
    var formatDateResult = DateFormat('EEEE, d MMMM y', 'id').format(today);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'WPDA',
      ),
      body: Consumer<LoginProvider>(
        builder: (context, value, _) {
          if (value.userId == null) {
            value.loadUserId();
            return CircularProgressIndicator();
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                wpdaProvider.refreshWpdaHistory(
                    value.userId!, (token == null) ? '' : token!);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Consumer<LoginProvider>(
                                  builder: (context, value, _) {
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
                                'Ayo, jadikan semua bangsa murid Tuhan.',
                                style: MyFonts.brownText(
                                  14,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        (_image == null)
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        content: InkWell(
                                          onTap: () {
                                            // Close the dialog when the image is tapped
                                          },
                                          child: Container(
                                            height: 300,
                                            width: 300,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage: AssetImage(
                                                'assets/images/profile_empty.jpg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
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
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        content: InkWell(
                                          onTap: () {
                                            // Close the dialog when the image is tapped
                                          },
                                          child: Container(
                                            height: 300,
                                            width: 300,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  FileImage(_image!),
                                              radius: 150,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
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
                              ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: (dropdownStateModel.selectedItem == "Semua")
                        ? FutureBuilder<List<WPDA>>(
                            future: Future.delayed(Duration(milliseconds: 600),
                                () => getWpdaUsecase.getAllWpda("${token}")),
                            builder: (context, snapshot) {
                              var data = snapshot.data;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return PlaceholderCardWpda();
                              } else {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/emoji.png',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                          ),
                                          SizedBox(height: 8),
                                          Center(
                                            child: Text(
                                              'Belum ada data WPDA',
                                              textAlign: TextAlign.center,
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                  } else {
                                    return Consumer<LoginProvider>(
                                        builder: (context, value, _) {
                                      if (value.userId == null) {
                                        value.loadUserId();
                                        return CircularProgressIndicator();
                                      } else {
                                        var currentDate = DateTime.now();
                                        var today = DateTime(currentDate.year,
                                            currentDate.month, currentDate.day);

                                        data = data!.reversed.toList();
                                        data!.sort((a, b) {
                                          var dateA =
                                              DateTime.parse(a.created_at);
                                          var dateB =
                                              DateTime.parse(b.created_at);

                                          // Menentukan tanggal hari ini tanpa memperhatikan jam dan menit
                                          var today = DateTime(
                                              currentDate.year,
                                              currentDate.month,
                                              currentDate.day);

                                          if (a.user_id == value.userId &&
                                              dateA.isAfter(today)) {
                                            return -1;
                                          } else if (b.user_id ==
                                                  value.userId &&
                                              dateB.isAfter(today)) {
                                            return 1;
                                          } else if (a.user_id ==
                                                  value.userId &&
                                              dateA.isAtSameMomentAs(today)) {
                                            return -1;
                                          } else if (b.user_id ==
                                                  value.userId &&
                                              dateB.isAtSameMomentAs(today)) {
                                            return 1;
                                          } else {
                                            return dateB.compareTo(
                                                dateA); // Jika bukan milik pengguna yang login, bandingkan berdasarkan tanggal secara umum
                                          }
                                        });

                                        return Column(
                                          children: [
                                            FutureBuilder<bool>(
                                              future:
                                                  checkIfWPDAUploadedTodayForUser(
                                                      value.userId!, data),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox(); // Show nothing while waiting for the future result
                                                } else if (snapshot.hasData &&
                                                    snapshot.data == false) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorRed,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.info,
                                                            color: MyColor
                                                                .whiteColor),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Anda belum WPDA hari ini.',
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            14,
                                                            FontWeight.w500,
                                                            MyColor.whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorGreen,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .emoji_emotions,
                                                            color: MyColor
                                                                .whiteColor),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Anda sudah WPDA hari ini.',
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            14,
                                                            FontWeight.w500,
                                                            MyColor.whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            SizedBox(height: 12),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          formatDateResult,
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            12,
                                                            FontWeight.bold,
                                                            MyColor.whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 32),
                                                  Consumer<DropdownStateModel>(
                                                      builder: (context,
                                                          dropdownState, _) {
                                                    return DropdownButton<
                                                        String>(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      icon: Icon(Icons
                                                          .arrow_drop_down_rounded),
                                                      enableFeedback: false,
                                                      isDense: false,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      underline: SizedBox(),
                                                      value: dropdownState
                                                          .selectedItem,
                                                      items: _items
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          child: Text(
                                                            value,
                                                            style: MyFonts
                                                                .customTextStyle(
                                                              14,
                                                              FontWeight.bold,
                                                              Colors.white,
                                                            ),
                                                          ),
                                                          value: value,
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          dropdownState
                                                              .setSelectedItem(
                                                                  value);
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Consumer<DropdownStateModel>(
                                              builder:
                                                  (context, dropdownState, _) {
                                                return Expanded(
                                                    child: ListView.builder(
                                                  itemCount: data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var wpda = data![index];
                                                    return CardWpda(
                                                      wpda: wpda,
                                                    );
                                                  },
                                                ));
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    });
                                  }
                                } else {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/emoji.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                        ),
                                        SizedBox(height: 8),
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Ada gangguan sepertinya',
                                                style: MyFonts.customTextStyle(
                                                  16,
                                                  FontWeight.bold,
                                                  MyColor.whiteColor,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Coba lagi atau kembali nanti.',
                                                style: MyFonts.customTextStyle(
                                                  12,
                                                  FontWeight.w500,
                                                  MyColor.greyText,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: ButtonWidget(
                                                  title: 'Coba lagi',
                                                  color: MyColor.primaryColor,
                                                  onPressed: () {
                                                    getWpdaUsecase
                                                        .getAllWpda(token!);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        PlaceholderHistory(),
                                        PlaceholderHistory(),
                                        PlaceholderHistory(),
                                        PlaceholderHistory(),
                                        SizedBox(height: 12),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          )
                        : FutureBuilder<List<WPDA>>(
                            future: Future.delayed(
                                Duration(milliseconds: 600),
                                () =>
                                    getWpdaUsecase.getWpdaObedEdom("${token}")),
                            builder: (context, snapshot) {
                              var data = snapshot.data;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return PlaceholderCardWpda();
                              } else {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/emoji.png',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                          ),
                                          SizedBox(height: 8),
                                          Center(
                                            child: Text(
                                              'Belum ada data WPDA',
                                              textAlign: TextAlign.center,
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                  } else {
                                    return Consumer<LoginProvider>(
                                        builder: (context, value, _) {
                                      if (value.userId == null) {
                                        value.loadUserId();
                                        return CircularProgressIndicator();
                                      } else {
                                        var currentDate = DateTime.now();
                                        var today = DateTime(currentDate.year,
                                            currentDate.month, currentDate.day);

                                        data = data!.reversed.toList();
                                        data!.sort((a, b) {
                                          var dateA =
                                              DateTime.parse(a.created_at);
                                          var dateB =
                                              DateTime.parse(b.created_at);

                                          // Menentukan tanggal hari ini tanpa memperhatikan jam dan menit
                                          var today = DateTime(
                                              currentDate.year,
                                              currentDate.month,
                                              currentDate.day);

                                          if (a.user_id == value.userId &&
                                              dateA.isAfter(today)) {
                                            return -1;
                                          } else if (b.user_id ==
                                                  value.userId &&
                                              dateB.isAfter(today)) {
                                            return 1;
                                          } else if (a.user_id ==
                                                  value.userId &&
                                              dateA.isAtSameMomentAs(today)) {
                                            return -1;
                                          } else if (b.user_id ==
                                                  value.userId &&
                                              dateB.isAtSameMomentAs(today)) {
                                            return 1;
                                          } else {
                                            return dateB.compareTo(
                                                dateA); // Jika bukan milik pengguna yang login, bandingkan berdasarkan tanggal secara umum
                                          }
                                        });

                                        return Column(
                                          children: [
                                            FutureBuilder<bool>(
                                              future:
                                                  checkIfWPDAUploadedTodayForUser(
                                                      value.userId!, data),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox(); // Show nothing while waiting for the future result
                                                } else if (snapshot.hasData &&
                                                    snapshot.data == false) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorRed,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.info,
                                                            color: MyColor
                                                                .whiteColor),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Anda belum WPDA hari ini.',
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            14,
                                                            FontWeight.w500,
                                                            MyColor.whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorGreen,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .emoji_emotions,
                                                            color: MyColor
                                                                .whiteColor),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Anda sudah WPDA hari ini.',
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            14,
                                                            FontWeight.w500,
                                                            MyColor.whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            SizedBox(height: 12),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          formatDateResult,
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            12,
                                                            FontWeight.bold,
                                                            MyColor.whiteColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 32),
                                                  Consumer<DropdownStateModel>(
                                                      builder: (context,
                                                          dropdownState, _) {
                                                    return DropdownButton<
                                                        String>(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      icon: Icon(Icons
                                                          .arrow_drop_down_rounded),
                                                      enableFeedback: false,
                                                      isDense: false,
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      underline: SizedBox(),
                                                      value: dropdownState
                                                          .selectedItem,
                                                      items: _items
                                                          .map((String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          child: Text(
                                                            value,
                                                            style: MyFonts
                                                                .customTextStyle(
                                                              14,
                                                              FontWeight.bold,
                                                              Colors.white,
                                                            ),
                                                          ),
                                                          value: value,
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          dropdownState
                                                              .setSelectedItem(
                                                                  value);
                                                        });
                                                      },
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            Consumer<DropdownStateModel>(
                                              builder:
                                                  (context, dropdownState, _) {
                                                return Expanded(
                                                    child: ListView.builder(
                                                  itemCount: data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var wpda = data![index];
                                                    return CardWpda(
                                                      wpda: wpda,
                                                    );
                                                  },
                                                ));
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                    });
                                  }
                                } else {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/emoji.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                        ),
                                        SizedBox(height: 8),
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Ada gangguan sepertinya',
                                                style: MyFonts.customTextStyle(
                                                  16,
                                                  FontWeight.bold,
                                                  MyColor.whiteColor,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'Coba lagi atau kembali nanti.',
                                                style: MyFonts.customTextStyle(
                                                  12,
                                                  FontWeight.w500,
                                                  MyColor.greyText,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: ButtonWidget(
                                                  title: 'Coba lagi',
                                                  color: MyColor.primaryColor,
                                                  onPressed: () {
                                                    getWpdaUsecase
                                                        .getAllWpda(token!);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        PlaceholderHistory(),
                                        PlaceholderHistory(),
                                        PlaceholderHistory(),
                                        PlaceholderHistory(),
                                        SizedBox(height: 12),
                                      ],
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
