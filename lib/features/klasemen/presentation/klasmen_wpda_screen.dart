import 'package:cached_network_image/cached_network_image.dart';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/monthly_data_wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/view_all_data_users/data/providers/view_all_data_user_provider.dart';
import 'package:diamond_generation_app/features/view_detail_all_data_users/presentation/view_detail_users.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/custom_dialog.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_all_user.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_card_wpda.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KlasmenWpdaScreen extends StatefulWidget {
  @override
  State<KlasmenWpdaScreen> createState() => _KlasmenWpdaScreenState();
}

class _KlasmenWpdaScreenState extends State<KlasmenWpdaScreen>
    with WidgetsBindingObserver {
  TextEditingController _findUserController = TextEditingController();

  bool isKeyboardVisible = false;

  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  String buildImageUrlWithStaticTimestamp(String? profilePicture) {
    final staticTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (profilePicture != null &&
        profilePicture.isNotEmpty &&
        profilePicture != 'null') {
      // Hilangkan bagian "public" dari URL
      final imageUrl =
          "https://gsjasungaikehidupan.com/storage/profile_pictures/${profilePicture}?timestamp=$staticTimestamp";
      return imageUrl;
    } else {
      return "${ApiConstants.baseUrlImage}/profile_pictures/profile_pictures/dummy.jpg";
    }
  }

  String _getCurrentMonth() {
    final now = DateTime.now();
    final monthFormat = DateFormat('MMMM', 'id_ID');
    return monthFormat.format(now);
  }

  String _getCurrentYear() {
    final now = DateTime.now();
    final yearFormat = DateFormat('yyyy', 'id_ID');
    return yearFormat.format(now);
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Klasmen WPDA',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: MyColor.colorLightBlue,
                ),
                child: Text(
                  '${_getCurrentMonth() + ' ' + _getCurrentYear()}',
                  style: MyFonts.customTextStyle(
                    16,
                    FontWeight.bold,
                    MyColor.whiteColor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: MyColor.colorLightBlue.withOpacity(0.6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info, size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Perhitungan ranking WPDA dihitung setiap bulan. User dengan ranking 1 sampai 3 akan mendapat reward. Selamat!🙌',
                        style: MyFonts.customTextStyle(
                          12,
                          FontWeight.w500,
                          MyColor.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: FutureBuilder(
              future: Future.delayed(
                Duration(milliseconds: 700),
                () => getUserUsecase
                    .getMonthlyDataForAllUsers((token == null) ? '' : token!),
              ),
              builder: (context, snapshot) {
                print(snapshot.data);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return PlaceholderAllUser();
                } else {
                  if (snapshot.hasData || snapshot.data != null) {
                    final data = snapshot.data;
                    if (snapshot.data!.data.isNotEmpty) {
                      // Urutkan data berdasarkan skor tinggi ke rendah
                      data!.data.sort((a, b) {
                        // Skor pengguna
                        double scoreA = (a.monthlyData.isNotEmpty)
                            ? a.monthlyData.first.totalWpda /
                                a.monthlyData.first.missedDaysTotal
                            : 0.0;
                        double scoreB = (b.monthlyData.isNotEmpty)
                            ? b.monthlyData.first.totalWpda /
                                b.monthlyData.first.missedDaysTotal
                            : 0.0;

                        // Urutkan secara descending
                        return scoreB.compareTo(scoreA);
                      });
                      return RefreshIndicator(
                        onRefresh: () async {
                          getUserUsecase
                              .getMonthlyDataForAllUsers(token!)
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: ListView.builder(
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (context, index) {
                            final dataUser = data.data[index];
                            final rank = index + 1;

                            // Hitung total WPDA dan skor
                            int totalWpda = dataUser.monthlyData.isNotEmpty
                                ? dataUser.monthlyData.first.totalWpda
                                : 0;
                            int missedDaysTotal =
                                dataUser.monthlyData.isNotEmpty
                                    ? dataUser.monthlyData.first.missedDaysTotal
                                    : 0;
                            double score = missedDaysTotal != 0
                                ? totalWpda / missedDaysTotal
                                : 0.0;

                            String imgUrl = buildImageUrlWithStaticTimestamp(
                                data.data[index].profilePicture ?? '');

                            imgUrl = imgUrl.replaceAll("/public", "");

                            return ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (rank == 1)
                                      ? SvgPicture.asset(
                                          'assets/icons/gold_medal.svg',
                                          height: 30,
                                          width: 30,
                                        )
                                      : (rank == 2)
                                          ? SvgPicture.asset(
                                              'assets/icons/perak_medal.svg',
                                              height: 30,
                                              width: 30,
                                            )
                                          : (rank == 3)
                                              ? SvgPicture.asset(
                                                  'assets/icons/perunggu_medal.svg',
                                                  height: 30,
                                                  width: 30,
                                                )
                                              : Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: MyColor.greyText
                                                        .withOpacity(0.5),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${rank}',
                                                      style: MyFonts
                                                          .customTextStyle(
                                                        14,
                                                        FontWeight.bold,
                                                        MyColor.whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                  SizedBox(width: 12),
                                  (imgUrl.isEmpty || imgUrl == null)
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/profile_empty.jpg'),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    imgUrl),
                                          ),
                                        ),
                                ],
                              ),
                              title: Text(
                                dataUser.fullName,
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.w500,
                                  MyColor.whiteColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataUser.email,
                                    style: MyFonts.customTextStyle(
                                      12,
                                      FontWeight.w500,
                                      MyColor.greyText,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Hari Terlewat ',
                                        style: MyFonts.customTextStyle(
                                          12,
                                          FontWeight.w500,
                                          MyColor.greyText,
                                        ),
                                      ),
                                      Text(
                                        '${missedDaysTotal}',
                                        style: MyFonts.customTextStyle(
                                          12,
                                          FontWeight.w500,
                                          MyColor.colorRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '${totalWpda} WPDA',
                                        style: MyFonts.customTextStyle(
                                          12,
                                          FontWeight.bold,
                                          MyColor.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        'Skor ${score.toStringAsFixed(2)}',
                                        style: MyFonts.customTextStyle(
                                          12,
                                          FontWeight.w500,
                                          MyColor.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text('Belum ada data'),
                      );
                    }
                  } else {
                    return Center(
                      child: Text('Tidak ada data ditemukan'),
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
}

class ButtonApproveUser extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color background;
  final void Function() onTap;

  const ButtonApproveUser({
    super.key,
    required this.iconData,
    required this.onTap,
    required this.iconColor,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 40,
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          splashColor: MyColor.primaryColor,
          child: Center(
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
