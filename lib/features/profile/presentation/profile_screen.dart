import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_generation_app/core/services/profile/profile_api.dart';
import 'package:diamond_generation_app/features/profile/widgets/profile_placeholder.dart';
import 'package:diamond_generation_app/features/profile/widgets/profile_placeholder_no_connection.dart';
import 'package:diamond_generation_app/shared/widgets/bottom_dialog_profile_screen.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
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

  String? token;
  String? userId;

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

  final TextEditingController _newAddress = TextEditingController();
  final TextEditingController _newPhoneNumber = TextEditingController();
  final TextEditingController _newGender = TextEditingController();
  final TextEditingController _newAge = TextEditingController();
  final TextEditingController _newAccountNumber = TextEditingController();
  final TextEditingController _newEmail = TextEditingController();
  final TextEditingController _newBirthPlace = TextEditingController();

  late SharedPreferences _prefs;
  final String key = 'birth_date';

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _saveBirthDate(DateTime birthDate) {
    _prefs.setString(key, birthDate.toIso8601String());
  }

  DateTime? _getBirthDate() {
    final String? dateString = _prefs.getString(key);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  final keyImageProfile = "image_profile";

  @override
  void initState() {
    super.initState();
    viewAllSharedPreferences();
    _initSharedPreferences();
    getUserId().then((userId) {
      if (userId != null) {
        loadImage();
      }
    });
    getToken();
    getVersion();
  }

  Future<void> clearImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyImageProfile);

    setState(() {
      _image = null;
    });
  }

  File? _image;

  Future<void> _getImageFromGallery() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Tidak ada koneksi internet
      // Tampilkan pesan atau lakukan tindakan yang sesuai
      print('Tidak ada koneksi internet');
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: MyColor.colorRed,
            content: Text(
              'Tidak ada koneksi internet',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.whiteColor,
              ),
            ),
          ),
        );
      });
      return;
    }

    if (connectivityResult != ConnectivityResult.none) {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null &&
          connectivityResult != ConnectivityResult.none) {
        setState(() {
          _image = File(pickedImage.path);
          Navigator.of(context).pop();
        });

        // Lanjutkan dengan proses upload hanya jika ada koneksi internet
        await ProfileAPI()
            .uploadProfilePicture(_image!.path, int.parse(userId!), token!)
            .then((value) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: MyColor.colorGreen,
                content: Text(
                  'Gambar berhasil diunggah',
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.w500,
                    MyColor.whiteColor,
                  ),
                ),
              ),
            );
          });
        });
        await saveImage(_image!).then((value) {
          print('Save berhasil');
        });
      }
    }
  }

  Future<void> saveImage(File imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyImageProfile);
    prefs.setString(keyImageProfile, imageFile.path);
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

  Future<void> clearDataProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyImageProfile);
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final getUserUsecase = Provider.of<GetUserUsecase>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Akun',
      ),
      body: Consumer<LoginProvider>(builder: (context, value, _) {
        if (value.userId == null) {
          value.loadUserId();
          return CircularProgressIndicator();
        } else {
          return FutureBuilder<Map<String, dynamic>>(
            future: Future.delayed(
              Duration(milliseconds: 500),
              () => getUserUsecase.getUserProfile(
                  int.parse(value.userId.toString()),
                  (token == null) ? '' : token!),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ProfilePlaceholder();
              } else if (snapshot.hasError) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/emoji.png',
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        SizedBox(height: 8),
                        PlaceholderErrorConnection(),
                        ButtonWidget(
                          title: 'Coba Lagi',
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            profileProvider
                                .refreshProfile(int.parse(userId!), token!)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                (connectivityResult == ConnectivityResult.none)
                                    ? SnackBar(
                                        content: Text(
                                          'Ada gangguan. Sepertinya koneksi terputus. Periksa koneksi Anda!',
                                          style: MyFonts.customTextStyle(
                                            12,
                                            FontWeight.w500,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        backgroundColor: MyColor.colorRed,
                                      )
                                    : SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Terhubung kembali',
                                              style: MyFonts.customTextStyle(
                                                12,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                            Icon(Icons.wifi),
                                          ],
                                        ),
                                        backgroundColor: MyColor.colorGreen,
                                      ),
                              );
                            });
                          },
                          color: MyColor.primaryColor,
                        ),
                        SizedBox(height: 12),
                        ProfilePlaceholderNoConnection(),
                      ],
                    ),
                  ),
                ));
              } else {
                print(userId);
                Map<String, dynamic> dataUser = snapshot.data!;
                if (dataUser['success']) {
                  Map<String, dynamic> user = dataUser['data'];
                  Map<String, dynamic> user_profile = user['user_profile'];
                  String date = user['created_at'];
                  String formatDate = DateFormat('dd MMMM yyyy', 'id')
                      .format(DateTime.parse(date));

                  _newAddress.text = user_profile['address'];

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
                      profileProvider.refreshProfile(
                          int.parse(value.userId!), token!);
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
                                    (_image != null)
                                        ? Hero(
                                            tag: 'profile_image',
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                top: 16,
                                                bottom: 18,
                                              ),
                                              height: 120,
                                              width: 120,
                                              child: ClipOval(
                                                child: Image.file(
                                                  _image!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 5.0,
                                                ),
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
                                            child: ClipOval(
                                              child: Image.asset(
                                                  'assets/images/profile_empty.jpg',
                                                  fit: BoxFit.cover),
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
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: (_image != null)
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.25
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.15,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      height: 6,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        color: MyColor.greyText,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 20,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          (_image != null)
                                                              ? BottomDialogProfileScreen(
                                                                  title:
                                                                      'Hapus Foto Profil',
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: MyColor
                                                                        .colorRed,
                                                                  ),
                                                                  onTap: () {
                                                                    ProfileAPI()
                                                                        .deleteProfilePicture(
                                                                            context,
                                                                            int.parse(
                                                                                userId!),
                                                                            token!)
                                                                        .then(
                                                                            (value) {
                                                                      clearDataProfilePicture();
                                                                    });
                                                                  },
                                                                )
                                                              : SizedBox(),
                                                          SizedBox(height: 32),
                                                          BottomDialogProfileScreen(
                                                            title:
                                                                'Unggah Foto Profil',
                                                            icon: Icon(
                                                              Icons.photo,
                                                              color: MyColor
                                                                  .whiteColor,
                                                            ),
                                                            onTap: () {
                                                              _getImageFromGallery();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
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
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors
                                        .white, // Warna latar belakang shimmer
                                    highlightColor: MyColor.colorLightBlue,
                                    child: Text(
                                      'NEW CREATION 1',
                                      style: MyFonts.customTextStyle(
                                        14,
                                        FontWeight.bold,
                                        MyColor.whiteColor,
                                      ),
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
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            setState(() {});
                                          });
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
                                    Consumer<RegisterFormProvider>(
                                      builder:
                                          (context, registerFormProvider, _) {
                                        return CardDetailProfile(
                                          controller: _newBirthPlace,
                                          onPressed: () {
                                            print(registerFormProvider
                                                .selectedDateOfBirth);
                                            _saveBirthDate(registerFormProvider
                                                .selectedDateOfBirth);
                                            profileProvider
                                                .updateProfile(
                                                    context,
                                                    {
                                                      'birth_place':
                                                          _newBirthPlace.text,
                                                      'birth_date':
                                                          registerFormProvider
                                                              .selectedDateOfBirth
                                                              .toString(),
                                                    },
                                                    value.userId!,
                                                    token!)
                                                .then((value) {
                                              Future.delayed(
                                                  Duration(seconds: 2), () {
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
                                        );
                                      },
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
