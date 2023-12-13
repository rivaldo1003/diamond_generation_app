import 'dart:convert';

import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/card_detail_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
    });
  }

  @override
  void initState() {
    getToken();
    getVersion();
    super.initState();
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
            future: getUserUsecase.getUserProfile(
                int.parse(value.userId.toString()),
                (token == null) ? '' : token!),
            builder: (context, snapshot) {
              print('SNAPSHOT : ${snapshot.data}');
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
                        'Koneksi server sedang error. Coba lagi nanti',
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
                  Map<String, dynamic> user = dataUser['data'];
                  Map<String, dynamic> user_profile = user['user_profile'];
                  String date = user_profile['created_at'];
                  var resultDate = date.split(' ').first;
                  String formatDate = DateFormat('dd MMMM yyyy', 'id')
                      .format(DateTime.parse(date));
                  print(user_profile);
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
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
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {},
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
                                '${user['full_name']}',
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
                                        '${user['role']}',
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
                                'Aktif sejak - ${formatDate}',
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
                                      'Informasi Pribadi',
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
                                    title: 'Nomor Akun',
                                    value: (user['account_number'] == null)
                                        ? 'Null'
                                        : user['account_number'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.campaign,
                                    title: 'Umur',
                                    value: user_profile['age'] + ' Tahun',
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.email,
                                    title: 'Email',
                                    value: user['email'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.home_rounded,
                                    title: 'Alamat',
                                    value: user_profile['address'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.phone,
                                    title: 'No Telepon',
                                    value: user_profile['phone_number'],
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.person,
                                    title: 'Jenis Kelamin',
                                    value: (user_profile['gender'] == 'Male')
                                        ? 'Laki-Laki'
                                        : 'Perempuan',
                                  ),
                                  SizedBox(height: 4),
                                  CardDetailProfile(
                                    iconData: Icons.add_location_alt,
                                    title: 'Tempat/Tanggal Lahir',
                                    value: user_profile['birth_place'] +
                                        ', ' +
                                        user_profile['birth_date'],
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
                          title: 'Keluar',
                          icon: Icons.logout,
                          color: MyColor.colorLogOut,
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Konfirmasi keluar akun',
                                      style: MyFonts.customTextStyle(
                                        16,
                                        FontWeight.bold,
                                        MyColor.whiteColor,
                                      ),
                                    ),
                                    content: Text(
                                      'Apakah anda yakin ingin keluar dari akun anda?',
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
                                          'Batal',
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
                                                  'Anda telah berhasil keluar.',
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
                                          'Keluar',
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
