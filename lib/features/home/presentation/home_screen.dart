import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:diamond_generation_app/core/services/profile/profile_api.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/detail_community/presentation/detail_community.dart';
import 'package:diamond_generation_app/features/home/data/providers/home_provider.dart';
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
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final List<String> imgList = [
  'assets/images/diamond.png',
  'assets/images/diamond.png',
  'assets/images/diamond.png',
  'assets/images/diamond.png',
  'assets/images/diamond.png',
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text('Diamond Generation',
                            style: MyFonts.customTextStyle(
                              16,
                              FontWeight.bold,
                              MyColor.whiteColor,
                            )),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

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

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);
    return Scaffold(
      appBar: AppBarWidget(title: 'Beranda'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                                          backgroundImage: FileImage(_image!),
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
                  Consumer<HomeProvider>(
                    builder: (context, homeProvider, _) => CarouselSlider(
                      items: imageSliders,
                      carouselController: _controller,
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        viewportFraction: 0.8,
                        onPageChanged: (index, reason) {
                          homeProvider.current = index;
                        },
                      ),
                    ),
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, homeProvider, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 6.0,
                            height: 6.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        homeProvider.current == entry.key
                                            ? 0.9
                                            : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                  FutureBuilder<Map<String, dynamic>>(
                    future: getUserUsecase
                        .getTotalNewUsers((token != null) ? token! : ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty ||
                              snapshot.data != null) {
                            var data = snapshot.data;
                            var totalUser = data!['total_users'];
                            var totalNewUser = data['total_new_users'];
                            var totalUserWithWpda =
                                data['total_user_with_wpda'];
                            return Container(
                              padding: EdgeInsets.only(
                                top: 20,
                                left: 20,
                                right: 20,
                                bottom: 30,
                              ),
                              decoration: BoxDecoration(
                                // color: MyColor.colorLightBlue.withOpacity(0.7),
                                color: MyColor.colorBlackBg,
                                borderRadius: BorderRadius.circular(15),
                                // border: Border.all(color: MyColor.whiteColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'DATA DG YOUTH',
                                            style: MyFonts.customTextStyle(
                                              20,
                                              FontWeight.bold,
                                              MyColor.whiteColor,
                                            ),
                                          ),
                                          Text(
                                            'Senin, 25 Desember 2023',
                                            style: MyFonts.customTextStyle(
                                              12,
                                              FontWeight.w500,
                                              MyColor.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'DIAMOND \nCOMMUNITY',
                                        style: MyFonts.customTextStyle(
                                          12,
                                          FontWeight.bold,
                                          MyColor.colorLightBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      CardBeranda(
                                        title: 'Sudah WPDA',
                                        subtitle1: '${totalUserWithWpda}',
                                        subtitle2: ' / ${totalUser} ',
                                        textColorSub2: Colors.grey[300],
                                        description: 'Orang',
                                      ),
                                      SizedBox(width: 12),
                                      CardBeranda(
                                        title: 'Pengguna',
                                        subtitle1: '${totalUser}',
                                        subtitle2: ' + ${totalNewUser}',
                                        textColorSub2: Colors.amber,
                                        description:
                                            'Jiwa Baru (1 bulan terakhir)',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      CardBeranda(
                                        title: 'Komunitas',
                                        subtitle1: '200',
                                        subtitle2: ' / 260',
                                        description: 'Orang',
                                      ),
                                      SizedBox(width: 12),
                                      CardBeranda(
                                        title: 'WPDA',
                                        subtitle1: '240',
                                        subtitle2: ' / 260',
                                        description: 'Orang',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Text('Data masih kosong'),
                            );
                          }
                        } else {
                          return Center(
                            child: Text('No data'),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardBeranda extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String description;
  Color? textColorSub2;

  CardBeranda({
    Key? key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.description,
    this.textColorSub2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: MyColor.colorLightBlue.withOpacity(0.9),
          // color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            splashColor: MyColor.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: MyFonts.customTextStyle(
                      12,
                      FontWeight.bold,
                      MyColor.whiteColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // color: MyColor.whiteColor,
                        ),
                        child: Text(
                          subtitle1,
                          style: MyFonts.customTextStyle(
                            24,
                            FontWeight.bold,
                            MyColor.whiteColor,
                          ),
                        ),
                      ),
                      Text(
                        subtitle2,
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.bold,
                          textColorSub2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: MyFonts.customTextStyle(
                      12,
                      FontWeight.w500,
                      MyColor.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
