import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardDetailProfile extends StatefulWidget {
  final IconData iconData;
  final String title;
  final String value;
  final bool? readOnly;
  TextEditingController? controller;
  void Function()? onPressed;
  TextInputType? keyboardType;

  CardDetailProfile({
    super.key,
    required this.iconData,
    required this.title,
    required this.value,
    this.readOnly,
    this.controller,
    this.onPressed,
    this.keyboardType,
  });

  @override
  State<CardDetailProfile> createState() => _CardDetailProfileState();
}

class _CardDetailProfileState extends State<CardDetailProfile> {
  late RegisterFormProvider formProv; //

  Future<void> saveGenderPreference(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key_gender', gender);
  }

  // Tambahkan fungsi berikut di dalam widget atau tempat yang sesuai
  Future<void> loadGenderPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString('key_gender');

    // Cek apakah nilai jenis kelamin sudah disimpan sebelumnya
    if (gender != null) {
      // Set nilai jenis kelamin ke dalam selectedGender
      if (gender == 'Male') {
        formProv.selectedGender = Gender.Male;
      } else {
        formProv.selectedGender = Gender.Female;
      }

      // Update nilai controller sesuai dengan selectedGender
      if (widget.title == 'Jenis Kelamin') {
        if (widget.controller != null) {
          widget.controller!.text =
              (gender == 'Male') ? 'Laki-Laki' : 'Perempuan';
        }
      }
    }
  }

// Panggil fungsi loadGenderPreference saat checkbox dibuka
  @override
  void initState() {
    super.initState();
    formProv = Provider.of<RegisterFormProvider>(context, listen: false);
    loadGenderPreference();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        loadGenderPreference();
        showDialog(
          context: (context),
          builder: (context) {
            return Consumer<RegisterFormProvider>(
                builder: (context, formProv, _) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          keyboardType: widget.keyboardType,
                          readOnly: (widget.readOnly == null)
                              ? false
                              : widget.readOnly!,
                          maxLines: (widget.title == 'Alamat') ? 4 : 1,
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.w500,
                            MyColor.whiteColor,
                          ),
                          controller: widget.controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        (widget.title == 'Tempat/Tanggal Lahir')
                            ? Consumer<RegisterFormProvider>(
                                builder: (context, registerFormProvider, _) {
                                  return GestureDetector(
                                    onTap: () => registerFormProvider
                                        .selectDate(context),
                                    child: Container(
                                      height: 48,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: MyColor.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (registerFormProvider
                                                          .selectedDateOfBirth !=
                                                      null)
                                                  ? registerFormProvider
                                                      .formatDate()
                                                  : 'Select Date',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.w500,
                                                MyColor.blackColor,
                                              ),
                                            ),
                                            Icon(
                                              Icons.calendar_month,
                                              color: MyColor.greyText,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(height: 12),
                    (widget.title == 'Jenis Kelamin')
                        ? Container(
                            height: 48,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // color: MyColor.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<Gender>(
                                    title: Text(
                                      'Laki-Laki',
                                      style: MyFonts.customTextStyle(
                                        12,
                                        FontWeight.w500,
                                        MyColor.greyText,
                                      ),
                                    ),
                                    value: Gender.Male,
                                    dense: true,
                                    groupValue: formProv.selectedGender,
                                    activeColor: MyColor.primaryColor,
                                    onChanged: (Gender? value) {
                                      formProv.selectedGender = value!;
                                      var data = formProv.selectedGender;
                                      var dataGender =
                                          data.toString().split('.').last;
                                      if (widget.title == 'Jenis Kelamin') {
                                        widget.controller!.text =
                                            (dataGender == 'Male')
                                                ? 'Laki-Laki'
                                                : 'Perempuan';
                                        // saveGenderPreference(dataGender);
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<Gender>(
                                    title: Text(
                                      'Perempuan',
                                      style: MyFonts.customTextStyle(
                                        12,
                                        FontWeight.w500,
                                        MyColor.greyText,
                                      ),
                                    ),
                                    value: Gender.Female,
                                    dense: true,
                                    activeColor: MyColor.primaryColor,
                                    groupValue: formProv.selectedGender,
                                    onChanged: (Gender? value) {
                                      formProv.selectedGender = value!;
                                      var data = formProv.selectedGender;
                                      var dataGender =
                                          data.toString().split('.').last;
                                      if (widget.title == 'Jenis Kelamin') {
                                        widget.controller!.text =
                                            (dataGender == 'Female')
                                                ? 'Perempuan'
                                                : 'Laki-Laki';
                                        // saveGenderPreference(dataGender);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 12),
                    (widget.readOnly == true && widget.title != 'Jenis Kelamin')
                        ? Container()
                        : ButtonWidget(
                            title: 'Simpan',
                            onPressed: () {
                              widget.onPressed!();
                              saveGenderPreference(formProv.selectedGender
                                  .toString()
                                  .split('.')
                                  .last);
                            },
                            color: MyColor.primaryColor,
                          )
                  ],
                ),
                title: Text(
                  widget.title,
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.w600,
                    MyColor.colorLightBlue,
                  ),
                ),
              );
            });
          },
        );
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 48,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: MyColor.colorBlackBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: 18),
                        Icon(widget.iconData),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: MyFonts.customTextStyle(
                              14,
                              FontWeight.w500,
                              MyColor.greyText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(
                        widget.value,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.greyText,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          (widget.readOnly == false || widget.title == 'Jenis Kelamin')
              ? Positioned(
                  top: 20,
                  left: 32,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: MyColor.colorLightBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
