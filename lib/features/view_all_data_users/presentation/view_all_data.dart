import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/view_detail_all_data_users/presentation/view_detail_users.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/custom_dialog.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllData extends StatefulWidget {
  @override
  State<ViewAllData> createState() => _ViewAllDataState();
}

class _ViewAllDataState extends State<ViewAllData> {
  TextEditingController _findUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);
    final searchUserProvider =
        Provider.of<SearchUserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBarWidget(title: 'All User'),
      body: FutureBuilder(
        future: searchUserProvider.fetchData(context, ApiConstants.getAllUser),
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
                    'Data not found!',
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
            List<AllUsers> usersData = searchUserProvider.filteredUserData;
            var result = usersData.map((e) {
              return e.profile_completed;
            });

            var dataLength = result.where((element) => element == "0").length;

            int countUserApprove =
                searchUserProvider.countUnapprovedUsers(usersData).toInt();

            return Consumer<LoginProvider>(builder: (context, value, _) {
              if (value.userId == null) value.loadUserId();
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: MyColor.colorBlackBg,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: MyColor.colorGreen,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Total users (${usersData.length} user).',
                              style: MyFonts.customTextStyle(
                                15,
                                FontWeight.w500,
                                MyColor.whiteColor,
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
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
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
                                    'Incomplete user profile data (${dataLength}).',
                                    style: MyFonts.customTextStyle(
                                      15,
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
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: MyColor.colorBlackBg,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.approval,
                                  color: MyColor.colorLightBlue,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  searchUserProvider
                                          .countUnapprovedUsers(usersData)
                                          .toString() +
                                      '${countUserApprove > 1 ? ' users waiting for approval' : ' user waiting for approval'}',
                                  style: MyFonts.customTextStyle(
                                    15,
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
                  }),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Consumer<SearchUserProvider>(
                      builder: (context, valueSearchProv, _) => TextFieldWidget(
                        hintText: 'Find user',
                        obscureText: false,
                        controller: _findUserController,
                        suffixIcon: Icon(Icons.search),
                        onChanged: (query) {
                          valueSearchProv.searchUser(query!);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await getUserUsecase.getAllUsers().then((value) {
                          setState(() {});
                        });
                      },
                      child: Consumer<SearchUserProvider>(
                        builder: (context, valueSearchPro, _) => (valueSearchPro
                                .filteredUserData.isNotEmpty)
                            ? ListView.builder(
                                itemCount:
                                    valueSearchPro.filteredUserData.length,
                                itemBuilder: (context, index) {
                                  usersData.sort((a, b) {
                                    if (a.statusPersetujuan == "approved" &&
                                        b.statusPersetujuan != "approved") {
                                      return 1;
                                    } else if (a.statusPersetujuan !=
                                            "approved" &&
                                        b.statusPersetujuan == "approved") {
                                      return -1;
                                    } else {
                                      return 0;
                                    }
                                  });
                                  final userData = searchUserProvider
                                      .filteredUserData[index];
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
                                          userData.fullName,
                                          style: MyFonts.customTextStyle(
                                            15,
                                            FontWeight.w500,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        subtitle: Text(
                                          userData.email,
                                          style: MyFonts.customTextStyle(
                                            13,
                                            FontWeight.w500,
                                            MyColor.greyText,
                                          ),
                                        ),
                                        leading: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            CircleAvatar(),
                                            Positioned(
                                              left: -5,
                                              top: -5,
                                              child: (userData
                                                          .profile_completed ==
                                                      "0")
                                                  ? Icon(
                                                      Icons.dangerous,
                                                      color: MyColor.greyText,
                                                    )
                                                  : Container(),
                                            ),
                                          ],
                                        ),
                                        trailing: (value.userId == userData.id)
                                            ? Container(
                                                height: 30,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  color: MyColor.colorGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'You',
                                                    style:
                                                        MyFonts.customTextStyle(
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
                                            padding: const EdgeInsets.all(20),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  (value.userId != userData.id)
                                                      ? Row(
                                                          children: [
                                                            (userData.statusPersetujuan ==
                                                                        "pending_approval" &&
                                                                    !viewValue
                                                                        .isApproved)
                                                                ? ButtonApproveUser(
                                                                    iconData: Icons
                                                                        .check,
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        builder:
                                                                            (context) {
                                                                          return CustomDialog(
                                                                            onApprovePressed:
                                                                                (context) {
                                                                              viewValue.approveUser({
                                                                                "user_id": userData.id,
                                                                                "new_status": "approved",
                                                                              }, context).then((value) {
                                                                                Future.delayed(Duration(seconds: 2), () {
                                                                                  setState(() {});
                                                                                });
                                                                              });
                                                                              // viewValue
                                                                              //     .approvedUserButton();
                                                                            },
                                                                            title:
                                                                                'Approve confirmation',
                                                                            content:
                                                                                'Are you sure you want to approve this user?',
                                                                            textColorYes:
                                                                                'Approve',
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    background:
                                                                        MyColor
                                                                            .colorGreen,
                                                                    iconColor:
                                                                        MyColor
                                                                            .whiteColor,
                                                                  )
                                                                : Container(),
                                                            SizedBox(width: 12),
                                                            ButtonApproveUser(
                                                              iconData:
                                                                  Icons.delete,
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (context) {
                                                                    return CustomDialog(
                                                                      onApprovePressed:
                                                                          (context) async {
                                                                        Future.delayed(
                                                                            Duration(seconds: 2),
                                                                            () {
                                                                          CircularProgressIndicator();
                                                                        });
                                                                        viewValue
                                                                            .deleteData(userData.id,
                                                                                context)
                                                                            .then((value) {
                                                                          Future.delayed(
                                                                              Duration(seconds: 2),
                                                                              () {
                                                                            setState(() {});
                                                                          });
                                                                        });
                                                                        ;
                                                                      },
                                                                      title:
                                                                          'Delete confirmation',
                                                                      content:
                                                                          'Are you sure you want to delete this user?',
                                                                      textColorYes:
                                                                          'Delete',
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              background:
                                                                  MyColor
                                                                      .colorRed,
                                                              iconColor: MyColor
                                                                  .whiteColor,
                                                            ),
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
                              )
                            : Center(
                                child: Text(
                                  'No users found',
                                  style: MyFonts.customTextStyle(
                                    14,
                                    FontWeight.w500,
                                    MyColor.whiteColor,
                                  ),
                                ),
                              ),
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
