import 'dart:convert';
import 'dart:io';

import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/features/profile/models/image.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/card_detail_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String appVersion = '';

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  File? _imageFile;
  File? resultImage;
  String? imageUrlCheck;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.uploadImageUrl),
      );
      request.fields['user_id'] = '203'; // Ganti dengan ID pengguna

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          imageFile.path,
        ),
      );

      try {
        final streamedResponse = await request.send();
        if (streamedResponse.statusCode == 200) {
          final response = await http.Response.fromStream(streamedResponse);
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData);

          // Jika gambar berhasil diunggah, atur gambar yang dipilih pada tampilan profil
          setState(() {
            _imageFile = imageFile;
          });
          fetchImage("203");
        } else {
          print('Upload failed');
        }
      } catch (e) {
        print('Error during upload: $e');
      }
    }
  }

  Future<void> fetchImage(String userId) async {
    final response = await http
        .get(Uri.parse(ApiConstants.readImageUrl + '?user_id=${userId}'));
    if (response.statusCode == 200) {
      final List<dynamic> dataImage = json.decode(response.body)['data'];
      for (var item in dataImage) {
        imageUrlCheck = item['image_path'];
        resultImage = File(imageUrlCheck!);
      }
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final getUserUsecase = Provider.of<GetUserUsecase>(context);

    return Scaffold(
      appBar: AppBarWidget(title: 'Account'),
      body: Consumer<LoginProvider>(builder: (context, value, _) {
        if (value.userId == null) {
          value.loadUserId();
          return CircularProgressIndicator();
        } else {
          return FutureBuilder<Map<String, dynamic>>(
            future: getUserUsecase
                .getUserProfile(int.parse(value.userId.toString())),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/emoji.png',
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Server connection error. Please try again later',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                Map<String, dynamic> dataUser = snapshot.data!;
                if (dataUser['success']) {
                  Map<String, dynamic> profileData = dataUser['profile_data'];
                  String date = profileData['registration_date'];
                  var resultDate = date.split(' ').first;
                  String formatDate = DateFormat('dd MMMM yyyy', 'id')
                      .format(DateTime.parse(date));
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  (_imageFile == null)
                                      ? Container(
                                          margin: EdgeInsets.only(
                                            top: 16,
                                            bottom: 18,
                                          ),
                                          height: 120,
                                          width: 120,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/profile_empty.jpg'),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 5.0,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                            top: 16,
                                            bottom: 18,
                                          ),
                                          height: 120,
                                          width: 120,
                                          child: CircleAvatar(
                                            backgroundImage:
                                                FileImage(resultImage!),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 5.0,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 20,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        _uploadImage();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Icon(Icons.add),
                                        decoration: BoxDecoration(
                                          color: MyColor.colorLightBlue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${profileData['full_name']}',
                                style: MyFonts.customTextStyle(
                                  18,
                                  FontWeight.bold,
                                  MyColor.whiteColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 24,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: MyColor.colorLightBlue,
                                      border: Border.all(
                                          // color: MyColor.primaryColor,
                                          ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${profileData['role']}',
                                        style: MyFonts.customTextStyle(
                                          14,
                                          FontWeight.bold,
                                          MyColor.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Active since - ${formatDate}',
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.w500,
                                  MyColor.greyText,
                                ),
                              ),
                              SizedBox(height: 32),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      'Personal Information',
                                      style: MyFonts.customTextStyle(
                                        14,
                                        FontWeight.w500,
                                        MyColor.whiteColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  CardDetailProfile(
                                    iconData: Icons.numbers,
                                    title: 'Account Number',
                                    value: profileData['account_number'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.email,
                                    title: 'Email',
                                    value: profileData['email'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.home_rounded,
                                    title: 'Address',
                                    value: profileData['address'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.phone,
                                    title: 'Phone',
                                    value: profileData['phone_number'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.person,
                                    title: 'Gender',
                                    value: profileData['gender'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.add_location_alt,
                                    title: 'Place and Date of Birth',
                                    value: profileData['birth_place'] +
                                        ', ' +
                                        profileData['birth_date'],
                                  ),
                                  SizedBox(height: 32),
                                  (appVersion != null)
                                      ? Center(
                                          child: Text(
                                            'App Version - ${appVersion} ',
                                            style: MyFonts.customTextStyle(
                                              12,
                                              FontWeight.w500,
                                              MyColor.greyText,
                                            ),
                                          ),
                                        )
                                      : CircularProgressIndicator(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ButtonWidget(
                          profileProvider: profileProvider,
                          title: 'Logout',
                          icon: Icons.logout,
                          color: MyColor.colorLogOut,
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Logout confirmation',
                                      style: MyFonts.customTextStyle(
                                        16,
                                        FontWeight.bold,
                                        MyColor.whiteColor,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to logout?',
                                      style: MyFonts.customTextStyle(
                                        14,
                                        FontWeight.w500,
                                        MyColor.whiteColor,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: MyFonts.customTextStyle(
                                            15,
                                            FontWeight.bold,
                                            Colors.lightBlue,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              });
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return LoginScreen();
                                              }),
                                              (route) => false,
                                            );
                                            profileProvider.clearAllData();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    MyColor.colorGreen,
                                                content: Text(
                                                  'You have successfully logged out.',
                                                  style:
                                                      MyFonts.customTextStyle(
                                                    15,
                                                    FontWeight.w500,
                                                    MyColor.whiteColor,
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                        child: Text(
                                          'Logout',
                                          style: MyFonts.customTextStyle(
                                            15,
                                            FontWeight.bold,
                                            Colors.lightBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text(
                      'Failed to retrieve user profile : ${dataUser['message']}');
                }
              }
            },
          );
        }
      }),
    );
  }
}
