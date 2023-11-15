import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/user_data_provider.dart';
import 'package:diamond_generation_app/features/detail_community/data/widgets/show_modal_bottom_sheet.dart';
import 'package:diamond_generation_app/features/detail_person/presentation/detail_person_screen.dart';
import 'package:diamond_generation_app/features/login/data/utils/user_controller.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/card_header_community.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DetailCommunity extends StatefulWidget {
  final String urlApi;
  final String title;

  DetailCommunity({
    super.key,
    required this.urlApi,
    required this.title,
  });

  @override
  State<DetailCommunity> createState() => _DetailCommunityState();
}

class _DetailCommunityState extends State<DetailCommunity> {
  late UserDataProvider _userDataProvider;

  @override
  void initState() {
    super.initState();

    _userDataProvider = UserDataProvider(context, widget.urlApi);
  }

  void dispose() {
    UserController.searchUserController.text = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);

    return Scaffold(
      appBar: AppBarWidget(title: widget.title),
      body: ChangeNotifierProvider.value(
        value: _userDataProvider,
        child: FutureBuilder<List<User>>(
          future: getUserUsecase.execute(widget.urlApi),
          builder: (context, snapshot) {
            final dataUser = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  var maleUserCount = dataUser!
                      .where((element) => element.gender == 'Male')
                      .length;
                  var femaleUserCount = dataUser
                      .where((element) => element.gender == 'Female')
                      .length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: MyColor.colorBlackBg.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              CardHeaderCommunity(
                                dataUser: snapshot.data!.length.toString(),
                                title: 'TOTAL ANGGOTA',
                                color: Colors.green,
                                onTap: () {},
                              ),
                              SizedBox(width: 8),
                              CardHeaderCommunity(
                                dataUser: maleUserCount.toString(),
                                title: 'TOTAL LAKI-LAKI',
                                color: Colors.blue,
                                onTap: () {},
                              ),
                              SizedBox(width: 8),
                              CardHeaderCommunity(
                                dataUser: femaleUserCount.toString(),
                                title: 'TOTAL PEREMPUAN',
                                color: Colors.pink,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<UserDataProvider>(
                        builder: (context, value, _) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFieldWidget(
                            hintText: 'Find user...',
                            obscureText: false,
                            onChanged: (query) {
                              value.searchUser(query!);
                            },
                            controller: UserController.searchUserController,
                            suffixIcon: Icon(
                              Icons.search,
                              color: MyColor.greyText,
                            ),
                          ),
                        ),
                      ),
                      Consumer<UserDataProvider>(
                        builder: (context, value, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                value.sortUser();
                              },
                              child: SvgPicture.asset(
                                (value.isSortedByName == false)
                                    ? 'assets/icons/sort_top.svg'
                                    : 'assets/icons/sort.svg',
                                color: MyColor.primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    builder: (context) {
                                      return ShowModalBottomSheeWidget();
                                    });
                              },
                              icon: Icon(
                                Icons.tune,
                                color: MyColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<UserDataProvider>(
                        builder: (context, value, _) => Expanded(
                          child: value.fiteredUser.isEmpty
                              ? Center(
                                  child: Text('No users found'),
                                )
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: value.fiteredUser.length,
                                  itemBuilder: (context, index) {
                                    var user = value.fiteredUser[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(user.images),
                                      ),
                                      title: Text(user.fullName),
                                      subtitle: Text(user.phoneNumber),
                                      trailing: Text(user.gender),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return DetailPerson(
                                            user: user,
                                          );
                                        }));
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text('Data is empty'),
                  );
                }
              } else {
                return Center(
                  child: Text('Has no data'),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
