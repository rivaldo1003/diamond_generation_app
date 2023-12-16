import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
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

  final TextEditingController _newAddress = TextEditingController();
  final TextEditingController _newPhoneNumber = TextEditingController();
  final TextEditingController _newGender = TextEditingController();
  final TextEditingController _newAge = TextEditingController();
  final TextEditingController _newAccountNumber = TextEditingController();
  final TextEditingController _newEmail = TextEditingController();
  final TextEditingController _newBirthPlace = TextEditingController();
  final TextEditingController _newBirthDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final getUserUsecase = Provider.of<GetUserUsecase>(context);

    return Scaffold(
      appBar: AppBarWidget(title: 'Akun'),
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/emoji.png',
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Koneksi server sedang bermasalah. Profil gagal dimuat!',
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
                Map<String, dynamic> dataUser = snapshot.data!;
                if (dataUser['success']) {
                  Map<String, dynamic> user = dataUser['data'];
                  Map<String, dynamic> user_profile = user['user_profile'];
                  String date = user['created_at'];
                  String formatDate = DateFormat('dd MMMM yyyy', 'id')
                      .format(DateTime.parse(date));

                  _newAddress.text = user_profile['address'];
                  // var birthAndPlace = user_profile['birth_place'] +
                  //     ', ' +
                  user_profile['birth_date'];
                  _newBirthPlace.text = user_profile['birth_place'];
                  _newPhoneNumber.text = user_profile['phone_number'];
                  _newGender.text = user_profile['gender'];
                  _newAccountNumber.text = user['account_number'];
                  _newEmail.text = user['email'];
                  _newAge.text = user_profile['age'] + ' Tahun';

                  // var data = registerFormProvider.selectedGender;
                  // var dataGender = data.toString().split('.').last;

                  return RefreshIndicator(
                    onRefresh: () async {
                      Future.delayed(Duration(seconds: 2));
                      // profileProvider.refreshProfile();
                    },
                    child: Column(
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
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColor.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'NEW CREATION 1',
                                    style: MyFonts.customTextStyle(
                                      14,
                                      FontWeight.bold,
                                      MyColor.whiteColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Informasi Pribadi',
                                            style: MyFonts.customTextStyle(
                                              14,
                                              FontWeight.w500,
                                              MyColor.whiteColor,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                height: 5,
                                                width: 5,
                                                decoration: BoxDecoration(
                                                  color: MyColor.colorLightBlue,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'Bisa diedit',
                                                style: MyFonts.customTextStyle(
                                                  12,
                                                  FontWeight.w500,
                                                  MyColor.greyText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    CardDetailProfile(
                                      readOnly: true,
                                      controller: _newAccountNumber,
                                      iconData: Icons.numbers,
                                      title: 'Nomor Akun',
                                      value: (user['account_number'] == null)
                                          ? 'Null'
                                          : user['account_number'],
                                    ),
                                    SizedBox(height: 4),
                                    CardDetailProfile(
                                      readOnly: true,
                                      controller: _newAge,
                                      iconData: Icons.campaign,
                                      title: 'Umur',
                                      value: user_profile['age'] + ' Tahun',
                                    ),
                                    SizedBox(height: 4),
                                    CardDetailProfile(
                                      controller: _newEmail,
                                      readOnly: true,
                                      iconData: Icons.email,
                                      title: 'Email',
                                      value: user['email'],
                                    ),
                                    SizedBox(height: 4),
                                    CardDetailProfile(
                                      controller: _newAddress,
                                      readOnly: false,
                                      iconData: Icons.home_rounded,
                                      title: 'Alamat',
                                      value: user_profile['address'],
                                      onPressed: () {
                                        profileProvider
                                            .updateProfile(
                                                context,
                                                {
                                                  'address': _newAddress.text,
                                                },
                                                value.userId!,
                                                token!)
                                            .then((value) {
                                          Future.delayed(
                                              Duration(seconds: 2), () {});
                                        });
                                      },
                                    ),
                                    SizedBox(height: 4),
                                    CardDetailProfile(
                                      keyboardType: TextInputType.number,
                                      readOnly: false,
                                      controller: _newPhoneNumber,
                                      onPressed: () {
                                        profileProvider
                                            .updateProfile(
                                                context,
                                                {
                                                  'phone_number':
                                                      _newPhoneNumber.text,
                                                },
                                                value.userId!,
                                                token!)
                                            .then((value) {
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            setState(() {});
                                          });
                                        });
                                      },
                                      iconData: Icons.phone,
                                      title: 'No Telepon',
                                      value: user_profile['phone_number'],
                                    ),
                                    SizedBox(height: 4),
                                    Consumer<RegisterFormProvider>(
                                      builder: (context, formProv, _) =>
                                          CardDetailProfile(
                                        controller: _newGender,
                                        readOnly: true,
                                        iconData: Icons.person,
                                        title: 'Jenis Kelamin',
                                        onPressed: () {
                                          print(_newGender.text);
                                          profileProvider
                                              .updateProfile(
                                                  context,
                                                  {
                                                    'gender': _newGender.text,
                                                  },
                                                  value.userId!,
                                                  token!)
                                              .then((value) {
                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              setState(() {});
                                            });
                                          });
                                        },
                                        value: user_profile['gender'],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    CardDetailProfile(
                                      controller: _newBirthPlace,
                                      onPressed: () {
                                        profileProvider
                                            .updateProfile(
                                                context,
                                                {
                                                  'birth_place':
                                                      _newBirthPlace.text,
                                                },
                                                value.userId!,
                                                token!)
                                            .then((value) {
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            setState(() {});
                                          });
                                        });
                                      },
                                      readOnly: false,
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
                    ),
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
