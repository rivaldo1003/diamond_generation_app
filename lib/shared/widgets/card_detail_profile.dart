import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/features/whatsapp_launcher/presentation/whatsapp_launcher.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardDetailProfile extends StatefulWidget {
  final Widget iconData;
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
  late RegisterFormProvider formProv;

  Future<void> saveGenderPreference(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferencesManager.keyGender, gender);
  }

  Future<void> loadGenderPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gender = prefs.getString(SharedPreferencesManager.keyGender);

    if (gender != null) {
      if (gender == 'Laki-Laki') {
        formProv.selectedGender = Gender.Male;
      } else {
        formProv.selectedGender = Gender.Female;
      }

      if (widget.title == 'Jenis Kelamin') {
        if (widget.controller != null) {
          widget.controller!.text =
              (gender == 'Laki-Laki') ? 'Laki-Laki' : 'Perempuan';
        }
      }
    } else {
      formProv.selectedGender = Gender.Male;

      if (widget.title == 'Jenis Kelamin' &&
          widget.controller!.text == 'Perempuan') {
        formProv.selectedGender = Gender.Female;
      }

      if (widget.title == 'Jenis Kelamin') {
        if (widget.controller != null) {
          widget.controller!.text = (formProv.selectedGender == Gender.Male)
              ? 'Laki-Laki'
              : 'Perempuan';
        }
      }
    }
  }

  String? originalSelectedDate;
  String? birthDate;

  Future<void> getBirthDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Gunakan nilai birthDate saat ini jika belum ada data di SharedPreferences
      birthDate =
          prefs.getString(SharedPreferencesManager.keyBirthDate) ?? birthDate;
    });
  }

  @override
  void initState() {
    super.initState();
    formProv = Provider.of<RegisterFormProvider>(context, listen: false);
    getBirthDate();
    loadGenderPreference();
    originalSelectedDate = birthDate;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.title == 'Alamat' || widget.title == 'No Telepon') {
            widget.controller!.text = widget.value;
          }
          originalSelectedDate = birthDate;
        });
        loadGenderPreference();
        showDialog(
          context: context,
          builder: (context) {
            return Consumer<RegisterFormProvider>(
              builder: (context, formProv, _) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
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
                              validator: (value) {
                                if (value!.isEmpty || value.length == null) {
                                  return 'Data tidak boleh kosong';
                                }
                              },
                            ),
                            SizedBox(height: 12),
                            (widget.title == 'Tempat/Tanggal Lahir')
                                ? Consumer<RegisterFormProvider>(
                                    builder:
                                        (context, registerFormProvider, _) {
                                      return GestureDetector(
                                        onTap: () async {
                                          await registerFormProvider.selectDate(
                                            context,
                                            initialDate: birthDate,
                                          );

                                          DateTime selectedBirthDate =
                                              registerFormProvider
                                                  .selectedDateOfBirth;

                                          // Menghitung umur
                                          DateTime currentDate = DateTime.now();
                                          int umur = currentDate.year -
                                              selectedBirthDate.year;
                                          if (currentDate.month <
                                                  selectedBirthDate.month ||
                                              (currentDate.month ==
                                                      selectedBirthDate.month &&
                                                  currentDate.day <
                                                      selectedBirthDate.day)) {
                                            umur--;
                                          }

                                          String? updatedBirthDate =
                                              registerFormProvider
                                                  .selectedDateOfBirth
                                                  .toIso8601String();

                                          setState(() {
                                            birthDate = updatedBirthDate;
                                            print(
                                                'Umur anda saat ini adalah${umur}');
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 48,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  // color: MyColor.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: MyColor.greyText)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      (birthDate != null)
                                                          ? DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(DateTime
                                                                  .parse(
                                                                      birthDate!))
                                                          : 'Pilih Tanggal',
                                                      style: MyFonts
                                                          .customTextStyle(
                                                        14,
                                                        FontWeight.w500,
                                                        MyColor.whiteColor,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.calendar_month,
                                                      color: MyColor.whiteColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      (widget.title == 'Jenis Kelamin')
                          ? Container(
                              // height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  RadioListTile<Gender>(
                                    title: Text(
                                      'Laki-Laki',
                                      style: MyFonts.customTextStyle(
                                        12,
                                        FontWeight.w500,
                                        MyColor.greyText,
                                      ),
                                    ),
                                    value: Gender.Male,
                                    dense: false,
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
                                      }
                                    },
                                  ),
                                  RadioListTile<Gender>(
                                    title: Text(
                                      'Perempuan',
                                      style: MyFonts.customTextStyle(
                                        12,
                                        FontWeight.w500,
                                        MyColor.greyText,
                                      ),
                                    ),
                                    value: Gender.Female,
                                    dense: false,
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
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 48),
                      (widget.readOnly == true &&
                              widget.title != 'Jenis Kelamin')
                          ? Container()
                          : (widget.onPressed == null)
                              ? SizedBox()
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
              },
            );
          },
        ).then((value) {
          setState(() {
            birthDate = originalSelectedDate;
          });
        });
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
                        SizedBox(width: 12),
                        widget.iconData,
                        SizedBox(width: 16),
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
                  top: 22,
                  left: 30,
                  child: Container(
                    height: 5,
                    width: 5,
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
