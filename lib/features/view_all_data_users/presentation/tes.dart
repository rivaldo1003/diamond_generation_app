import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/view_all_data_users/presentation/view_all_data.dart';
import 'package:diamond_generation_app/features/view_detail_all_data_users/presentation/view_detail_users.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/custom_dialog.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllData extends StatelessWidget {
  TextEditingController _findUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);

    return Scaffold(
      appBar: AppBarWidget(title: 'All User'),
      body: ChangeNotifierProvider<SearchUserProvider>(
        create: (_) => SearchUserProvider(getUserUsecase: getUserUsecase),
        builder: (context, _) {
          return Consumer<SearchUserProvider>(
            builder: (context, searchUserProvider, _) {
              return FutureBuilder(
                future: searchUserProvider.fetchData(
                    context, ApiConstants.getAllUser),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.hasError.toString()),
                    );
                  } else {
                    List<AllUsers> usersData =
                        searchUserProvider.filteredUserData;
                    var result = usersData.map((e) {
                      return e.profile_completed;
                    });
                    String? lengthUserWaitingApprove;

                    var resultWaitingApprove = usersData.map((e) {
                      e.statusPersetujuan
                          .contains("pending_approval")
                          .toString();
                      return e.statusPersetujuan;
                    });

                    int countUnapprovedUsers(List<AllUsers> users) {
                      int count = 0;
                      for (var user in users) {
                        if (user.statusPersetujuan != "approved") {
                          count++;
                        }
                      }
                      return count;
                    }

                    return Column(
                      children: [
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
                                          'Incomplete user profile data.',
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
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Consumer<SearchUserProvider>(
                            builder: (context, value, _) => TextFieldWidget(
                              hintText: 'Find user',
                              obscureText: false,
                              controller: _findUserController,
                              suffixIcon: Icon(Icons.search),
                              onChanged: (query) {
                                value.searchUser(query!);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ChangeNotifierProvider.value(
                            value: searchUserProvider,
                            child: RefreshIndicator(
                              onRefresh: () async =>
                                  searchUserProvider.refreshAllUsers(),
                              child: Consumer<SearchUserProvider>(
                                builder: (context, valueSearchProv, _) {
                                  return ListView.builder(
                                    itemCount:
                                        valueSearchProv.filteredUserData.length,
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
                                                          color:
                                                              MyColor.greyText,
                                                        )
                                                      : Container(),
                                                ),
                                              ],
                                            ),
                                            trailing: (1 == userData.id)
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
                                                      (1 != userData.id)
                                                          ? Row(
                                                              children: [
                                                                (userData.statusPersetujuan ==
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
                                                                                  searchUserProvider.approveUser({
                                                                                    "user_id": userData.id,
                                                                                    "new_status": "approved",
                                                                                  }, context);
                                                                                },
                                                                                title: 'Approve confirmation',
                                                                                content: 'Are you sure you want to approve this user?',
                                                                                textColorYes: 'Approve',
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
                                                                ButtonApproveUser(
                                                                  iconData: Icons
                                                                      .delete,
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
                                                                            Future.delayed(Duration(seconds: 2),
                                                                                () {
                                                                              CircularProgressIndicator();
                                                                            });
                                                                            searchUserProvider.deleteData(userData.id,
                                                                                context);
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
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
