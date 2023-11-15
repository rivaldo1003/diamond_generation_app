import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/view_detail_all_data_users/presentation/view_detail_users.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);
    return Scaffold(
      appBar: AppBarWidget(title: 'All User'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUserUsecase.getAllUsers(),
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
                  List<AllUsers> usersData = snapshot.data! ?? [];
                  var result = usersData.map((e) {
                    return e.profile_completed;
                  });
                  return Consumer<LoginProvider>(builder: (context, value, _) {
                    if (value.userId == null) value.loadUserId();
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
                                          color: MyColor.colorRed,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Incomplete user profile data',
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
                        Expanded(
                          child: ListView.builder(
                            itemCount: usersData.length,
                            itemBuilder: (context, index) {
                              final userData = usersData[index];
                              final historyWpda = userData.dataWpda;
                              return ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
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
                                leading: CircleAvatar(),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (value.userId == userData.id)
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
                                                style: MyFonts.customTextStyle(
                                                  14,
                                                  FontWeight.bold,
                                                  MyColor.whiteColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    (userData.profile_completed == "0")
                                        ? Icon(
                                            Icons.dangerous,
                                            color: MyColor.colorRed,
                                          )
                                        : Container(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
