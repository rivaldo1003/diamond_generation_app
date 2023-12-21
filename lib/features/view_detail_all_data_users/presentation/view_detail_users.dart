import 'package:cached_network_image/cached_network_image.dart';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/features/view_detail_all_data_users/presentation/wpda_user_screen.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/card_detail_profile.dart';
import 'package:diamond_generation_app/shared/widgets/detail_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewAllDataUsers extends StatefulWidget {
  final AllUsers userData;

  ViewAllDataUsers({
    super.key,
    required this.userData,
  });

  @override
  State<ViewAllDataUsers> createState() => _ViewAllDataUsersState();
}

class _ViewAllDataUsersState extends State<ViewAllDataUsers> {
  String? birthPlace;

  DateTime? dateTimeBirth;

  String? formattedDate;

  TextEditingController _controllerAccountNumber = TextEditingController();

  TextEditingController _controllerAge = TextEditingController();

  TextEditingController _controllerEmail = TextEditingController();

  TextEditingController _controllerAddress = TextEditingController();

  TextEditingController _controllerPhoneNumber = TextEditingController();

  TextEditingController _controllerGender = TextEditingController();

  TextEditingController _controllerBirthDateAndPlace = TextEditingController();

  String buildImageUrlWithTimestamp(String? profilePicture) {
    // Periksa apakah profilePicture tidak null dan tidak kosong sebelum membangun URL
    if (profilePicture != null && profilePicture.isNotEmpty) {
      return "${ApiConstants.baseUrlImage}/$profilePicture?timestamp=${DateTime.now().millisecondsSinceEpoch}";
    } else {
      // Handle ketika profilePicture null atau kosong, misalnya mengembalikan URL default atau kosong
      return ""; // Gantilah dengan URL default atau kosong sesuai kebutuhan
    }
  }

  String? imgUrl;

  @override
  void initState() {
    if (widget.userData.profile!.profile_picture.isNotEmpty) {
      imgUrl =
          buildImageUrlWithTimestamp(widget.userData.profile!.profile_picture);
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userData.profile != null) {
      dateTimeBirth = DateTime.parse(widget.userData.profile!.birth_date);
      formattedDate = DateFormat('d MMMM yyyy', 'id').format(dateTimeBirth!);
    }
    return Scaffold(
      appBar: AppBarWidget(title: 'Detail Pengguna'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: InkWell(
                            onTap: () {},
                            child: Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: (imgUrl != null)
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(imgUrl!),
                                    )
                                  : CircleAvatar(
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
                    margin: EdgeInsets.only(
                      top: 16,
                      bottom: 18,
                    ),
                    height: 120,
                    width: 120,
                    child: (imgUrl!.isEmpty)
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/profile_empty.jpg'),
                            backgroundColor: Colors.white,
                            radius: 20,
                          )
                        : CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(imgUrl!),
                            backgroundColor: Colors.white,
                            radius: 20,
                          ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0,
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.userData.fullName,
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
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 24,
                      width: 70,
                      decoration: BoxDecoration(
                        color: MyColor.colorLightBlue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          widget.userData.role,
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
                  'Aktif sejak - ${widget.userData.createdAt}',
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    DetailUser(
                      readOnly: true,
                      iconData: Icons.numbers,
                      title: 'Nomor Akun',
                      value: widget.userData.accountNumber,
                      controller: _controllerAccountNumber,
                    ),
                    SizedBox(height: 4),
                    DetailUser(
                      readOnly: true,
                      iconData: Icons.campaign,
                      title: 'Umur',
                      value: (widget.userData.profile == null)
                          ? '-'
                          : widget.userData.profile!.age + ' Tahun',
                      controller: _controllerAge,
                    ),
                    SizedBox(height: 4),
                    DetailUser(
                      readOnly: true,
                      iconData: Icons.email,
                      title: 'Email',
                      value: widget.userData.email,
                      controller: _controllerEmail,
                    ),
                    SizedBox(height: 4),
                    DetailUser(
                      readOnly: true,
                      iconData: Icons.home_rounded,
                      title: 'Alamat',
                      value: (widget.userData.profile == null)
                          ? '-'
                          : widget.userData.profile!.address,
                      controller: _controllerAddress,
                    ),
                    SizedBox(height: 4),
                    DetailUser(
                      readOnly: true,
                      iconData: Icons.phone,
                      title: 'No Telepon',
                      value: (widget.userData.profile == null)
                          ? '-'
                          : widget.userData.profile!.phone_number,
                      controller: _controllerPhoneNumber,
                    ),
                    SizedBox(height: 4),
                    DetailUser(
                      readOnly: true,
                      iconData: Icons.person,
                      title: 'Jenis Kelamin',
                      value: (widget.userData.profile == null)
                          ? '-'
                          : (widget.userData.profile!.gender == 'Male')
                              ? 'Laki-Laki'
                              : 'Perempuan',
                      controller: _controllerGender,
                    ),
                    SizedBox(height: 4),
                    DetailUser(
                      readOnly: true,
                      iconData: Icons.add_location_alt,
                      title: 'Tempat/Tanggal Lahir',
                      value: (widget.userData.profile == null)
                          ? '-'
                          : '${widget.userData.profile!.birth_place}' +
                              ', ' +
                              '${formattedDate}',
                      controller: _controllerBirthDateAndPlace,
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ButtonWidget(
              title: 'Lihat WPDA',
              color: MyColor.primaryColor,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WpdaUserScreen(
                    allUsers: widget.userData,
                    totalWpda: widget.userData.dataWpda.length.toString(),
                  );
                }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
