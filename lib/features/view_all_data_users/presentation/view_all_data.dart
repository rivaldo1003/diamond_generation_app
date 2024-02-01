import 'package:cached_network_image/cached_network_image.dart';
import 'package:diamond_generation_app/core/models/all_users.dart';
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
import 'package:diamond_generation_app/shared/widgets/build_image_url_with_timestamp.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/custom_dialog.dart';
import 'package:diamond_generation_app/shared/widgets/placeholder_all_user.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAllData extends StatefulWidget {
  @override
  State<ViewAllData> createState() => _ViewAllDataState();
}

class _ViewAllDataState extends State<ViewAllData> with WidgetsBindingObserver {
  TextEditingController _findUserController = TextEditingController();

  bool isKeyboardVisible = false;

  String? token;
  String? role;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  Future getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString(SharedPreferencesManager.keyRole);
      print(role);
    });
  }

  @override
  void initState() {
    getToken();
    getRole();
    super.initState();
  }

  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  String? capitalizeEachWord(String? text) {
    if (text == null || text.isEmpty) {
      return text;
    }

    List<String> words = text.split(" ");
    for (int i = 0; i < words.length; i++) {
      words[i] = capitalizeFirstLetter(words[i]);
    }

    return words.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context, listen: false);
    final searchUserProvider =
        Provider.of<SearchUserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Semua Pengguna',
        action: [
          Consumer<ViewAllDataProvider>(builder: (context, value, _) {
            if (value.isKeyboardVisible) {
              return IconButton(
                onPressed: () {
                  value.setKeyboardVisibility(false);
                },
                icon: Icon(Icons.visibility),
              );
            } else {
              return SizedBox();
            }
          }),
        ],
      ),
      body: FutureBuilder(
        future: Future.delayed(
          Duration(seconds: 1),
          () => searchUserProvider.fetchData(
              context, ApiConstants.getAllUser, (token == null) ? '' : token!),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PlaceholderAllUser();
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Image.asset(
                  'assets/images/emoji.png',
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                SizedBox(height: 8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonWidget(
                    title: 'Coba lagi',
                    color: MyColor.primaryColor,
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: PlaceholderAllUser(),
                ),
              ],
            );
          } else {
            List<AllUsers> usersData = searchUserProvider.filteredUserData;
            var result = usersData.map((e) {
              return e.profileCompleted;
            });
            var admin = usersData
                .where((user) =>
                    user.role == 'super_admin' || user.role == 'admin')
                .toList();

            int totalAdminUser = admin.length;

            var dataLength = result.where((element) => element == "0").length;
            int countUserApprove =
                searchUserProvider.countUnapprovedUsers(usersData).toInt();

            return Consumer<LoginProvider>(builder: (context, value, _) {
              if (value.userId == null) value.loadUserId();
              return Column(
                children: [
                  Consumer<ViewAllDataProvider>(
                    builder: (context, viewData, _) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (viewData.isKeyboardVisible) {
                            // Keyboard is visible, hide data
                            return SizedBox();
                          } else {
                            // Keyboard is not visible, show data
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: MyColor.colorBlackBg,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: MyColor.colorGreen,
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total pengguna (${usersData.length} pengguna).',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Total admin ${totalAdminUser}',
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
                                  ),
                                  SizedBox(height: 4),
                                  (result.contains("0"))
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: MyColor.colorBlackBg,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.dangerous,
                                                    color: MyColor.greyText,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Data profil belum lengkap (${dataLength}).',
                                                    style:
                                                        MyFonts.customTextStyle(
                                                      14,
                                                      FontWeight.w500,
                                                      MyColor.whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(height: 4),
                                  Consumer<SearchUserProvider>(
                                    builder: (context, valueSearchUser, _) {
                                      if (!valueSearchUser.isApproved) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: MyColor.colorBlackBg,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.approval,
                                                    color:
                                                        MyColor.colorLightBlue,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    searchUserProvider
                                                            .countUnapprovedUsers(
                                                                usersData)
                                                            .toString() +
                                                        '${countUserApprove > 1 ? ' menunggu persetujuan' : ' menunggu persetujuan'}',
                                                    style:
                                                        MyFonts.customTextStyle(
                                                      14,
                                                      FontWeight.w500,
                                                      MyColor.whiteColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  if (isKeyboardVisible) ...[
                    Text(
                      'Keyboard is visible!',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Consumer<SearchUserProvider>(
                      builder: (context, valueSearchProv, _) =>
                          Consumer<ViewAllDataProvider>(
                        builder: (context, valueViewAllDataProvider, _) =>
                            TextFieldWidget(
                          hintText: 'Temukan user',
                          obscureText: false,
                          controller: _findUserController,
                          suffixIcon: Icon(Icons.search),
                          onTap: () {
                            print(valueViewAllDataProvider.isKeyboardVisible);

                            valueViewAllDataProvider
                                .setKeyboardVisibility(true);
                          },
                          onChanged: (query) {
                            valueSearchProv.searchUser(query!);
                          },
                          onFieldSubmitted: (value) {
                            valueViewAllDataProvider
                                .setKeyboardVisibility(false);
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await getUserUsecase
                            .getAllUsers((token == null) ? '' : token!)
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Consumer<SearchUserProvider>(
                        builder: (context, valueSearchPro, _) => (valueSearchPro
                                .filteredUserData.isNotEmpty)
                            ? Consumer<LoginProvider>(
                                builder: (context, valueLoginProvider, _) {
                                if (value.userId == null) {
                                  value.loadUserId();
                                  return CircularProgressIndicator();
                                } else {
                                  return ListView.builder(
                                    itemCount:
                                        valueSearchPro.filteredUserData.length,
                                    itemBuilder: (context, index) {
                                      usersData.sort((a, b) {
                                        if (a.approvalStatus == "approved" &&
                                            b.approvalStatus != "approved") {
                                          return 1;
                                        } else if (a.approvalStatus !=
                                                "approved" &&
                                            b.approvalStatus == "approved") {
                                          return -1;
                                        } else {
                                          if (a.id == value.userId) {
                                            return -1;
                                          } else if (b.id == value.userId) {
                                            return 1;
                                          } else {
                                            return 0;
                                          }
                                        }
                                      });
                                      final userData = searchUserProvider
                                          .filteredUserData[index];

                                      String imgUrl =
                                          buildImageUrlWithStaticTimestamp(
                                              '${userData.profile?.profile_picture}' ??
                                                  '');

                                      imgUrl = imgUrl.replaceAll("/public", "");

                                      return Stack(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ViewAllDataUsers(
                                                  userData: userData,
                                                );
                                              }));
                                            },
                                            title: Text(
                                              capitalizeEachWord(
                                                  userData.fullName)!,
                                              overflow: TextOverflow.ellipsis,
                                              style: MyFonts.customTextStyle(
                                                15,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userData.email,
                                                  style:
                                                      MyFonts.customTextStyle(
                                                    13,
                                                    FontWeight.w500,
                                                    MyColor.greyText,
                                                  ),
                                                ),
                                                (userData.dataWpda.isEmpty)
                                                    ? Text(
                                                        'Belum pernah WPDA',
                                                        style: MyFonts
                                                            .customTextStyle(
                                                          13,
                                                          FontWeight.w500,
                                                          MyColor.colorRed,
                                                        ),
                                                      )
                                                    : SizedBox()
                                              ],
                                            ),
                                            leading: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                (imgUrl.isEmpty ||
                                                        imgUrl == null)
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: (userData.role ==
                                                                        'admin' ||
                                                                    userData.role ==
                                                                        'super_admin')
                                                                ? MyColor
                                                                    .primaryColor
                                                                : Colors
                                                                    .white, // Warna border putih
                                                            width:
                                                                2.0, // Lebar border
                                                          ),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/images/profile_empty.jpg'),
                                                        ),
                                                      )
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: (userData.role ==
                                                                        'admin' ||
                                                                    userData.role ==
                                                                        'super_admin')
                                                                ? MyColor
                                                                    .primaryColor
                                                                : Colors
                                                                    .white, // Warna border putih
                                                            width:
                                                                2.0, // Lebar border
                                                          ),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  imgUrl),
                                                        ),
                                                      ),
                                                Positioned(
                                                  left: -5,
                                                  top: -5,
                                                  child: (userData
                                                              .profileCompleted ==
                                                          "0")
                                                      ? Icon(
                                                          Icons.dangerous,
                                                          color:
                                                              MyColor.greyText,
                                                        )
                                                      : Container(),
                                                ),
                                              ],
                                            ),
                                            trailing: (value.userId ==
                                                    userData.id)
                                                ? Container(
                                                    height: 30,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorGreen,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'You',
                                                        style: MyFonts
                                                            .customTextStyle(
                                                          14,
                                                          FontWeight.bold,
                                                          MyColor.whiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          Consumer<SearchUserProvider>(
                                            builder: (context, viewValue, _) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      (value.userId !=
                                                              userData.id)
                                                          ? Row(
                                                              children: [
                                                                (userData.approvalStatus ==
                                                                            "pending_approval" &&
                                                                        !viewValue
                                                                            .isApproved)
                                                                    ? ButtonApproveUser(
                                                                        iconData:
                                                                            Icons.check,
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                false,
                                                                            builder:
                                                                                (context) {
                                                                              return CustomDialog(
                                                                                onApprovePressed: (context) {
                                                                                  viewValue.approveUser(context, (token == null) ? '' : token!, userData.id).then((value) {
                                                                                    Future.delayed(Duration(seconds: 2), () {
                                                                                      setState(() {});
                                                                                    });
                                                                                  });
                                                                                },
                                                                                title: 'Setujui Konfirmasi',
                                                                                content: 'Apakah Anda yakin ingin menyetujui pengguna ini?',
                                                                                textColorYes: 'Setujui',
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        background:
                                                                            MyColor.colorGreen,
                                                                        iconColor:
                                                                            MyColor.whiteColor,
                                                                      )
                                                                    : Container(),
                                                                SizedBox(
                                                                    width: 12),
                                                                (role ==
                                                                        'super_admin')
                                                                    ? ButtonApproveUser(
                                                                        iconData:
                                                                            Icons.delete,
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            barrierDismissible:
                                                                                false,
                                                                            builder:
                                                                                (context) {
                                                                              return CustomDialog(
                                                                                onApprovePressed: (context) async {
                                                                                  Future.delayed(Duration(seconds: 2), () {
                                                                                    CircularProgressIndicator();
                                                                                  });
                                                                                  viewValue.deleteData(userData.id, context, (token == null) ? '' : token!).then((value) {
                                                                                    Future.delayed(Duration(seconds: 2), () {
                                                                                      setState(() {});
                                                                                    });
                                                                                  });
                                                                                  ;
                                                                                },
                                                                                title: 'Hapus konfirmasi',
                                                                                content: 'Apakah anda yakin ingin menghapus user ini? semua data WPDA juga akan ikut terhapus. Mohon diperhatikan!',
                                                                                textColorYes: 'Hapus',
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        background:
                                                                            MyColor.colorRed,
                                                                        iconColor:
                                                                            MyColor.whiteColor,
                                                                      )
                                                                    : SizedBox(),
                                                              ],
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              })
                            : PlaceholderAllUser(),
                      ),
                    ),
                  ),
                ],
              );
            });
          }
        },
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
