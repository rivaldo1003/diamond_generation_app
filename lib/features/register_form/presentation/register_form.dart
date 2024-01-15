import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final registerFormProvider = Provider.of<RegisterFormProvider>(context);

    return Scaffold(
      appBar: AppBarWidget(title: 'Masukkan Data Pribadi'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Consumer<LoginProvider>(
                          builder: (context, loginProvider, _) {
                            if (loginProvider.fullName == null) {
                              loginProvider.loadFullName();
                              return CircularProgressIndicator();
                            } else {
                              registerFormProvider.fullNameController.text =
                                  loginProvider.fullName!;
                              return TextFieldWidget(
                                hintText: 'Nama Lengkap',
                                readOnly: true,
                                suffixIcon: Icon(Icons.person),
                                obscureText: false,
                                focusNode:
                                    registerFormProvider.fullNameFocusNode,
                                controller:
                                    registerFormProvider.fullNameController,
                                onChanged: (value) {},
                              );
                            }
                          },
                        ),
                        SizedBox(height: 12),
                        TextFieldWidget(
                          hintText: 'Alamat Tempat Tinggal',
                          suffixIcon: Icon(Icons.location_on),
                          obscureText: false,
                          focusNode: registerFormProvider.addressFocusNode,
                          controller: registerFormProvider.addressController,
                          errorText:
                              registerFormProvider.showRequiredMessageAddress
                                  ? 'Alamat wajib diisi'
                                  : null,
                          onChanged: (value) {
                            registerFormProvider.showRequiredMessageAddress =
                                false;
                            registerFormProvider.notifyListeners();
                          },
                        ),
                        SizedBox(height: 12),
                        TextFieldWidget(
                          hintText: 'Nomor Telepon',
                          keyboardType: TextInputType.phone,
                          suffixIcon: Icon(Icons.phone),
                          obscureText: false,
                          focusNode: registerFormProvider.phoneNumberFocusNode,
                          controller:
                              registerFormProvider.phoneNumberController,
                          errorText: registerFormProvider
                                  .showRequiredMessagePhoneNumber
                              ? 'Nomor Telepon wajib diisi'
                              : null,
                          onChanged: (value) {
                            registerFormProvider
                                .showRequiredMessagePhoneNumber = false;
                            registerFormProvider.notifyListeners();
                          },
                        ),
                        SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tempat dan Tanggal Lahir',
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.whiteColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    hintText: 'Tempat Lahir',
                                    obscureText: false,
                                    focusNode: registerFormProvider
                                        .placeOfBirthFocusNode,
                                    controller: registerFormProvider
                                        .placeOfBirthController,
                                    errorText: registerFormProvider
                                            .showRequiredMessagePlaceOfBirth
                                        ? 'Tempat Lahir wajib diisi'
                                        : null,
                                    onChanged: (value) {
                                      registerFormProvider
                                              .showRequiredMessagePlaceOfBirth =
                                          false;
                                      registerFormProvider.notifyListeners();
                                    },
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      GestureDetector(
                                        onTap: () => registerFormProvider
                                            .selectDate(context),
                                        child: Container(
                                          height: 48,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: MyColor.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  (registerFormProvider
                                                              .selectedDateOfBirth !=
                                                          null)
                                                      ? registerFormProvider
                                                          .formatDate()
                                                      : 'Select Date',
                                                  style:
                                                      MyFonts.customTextStyle(
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
                                      ),
                                      SizedBox(height: 4),
                                      Visibility(
                                        visible:
                                            (registerFormProvider.calculateAge(
                                                        registerFormProvider
                                                            .selectedDateOfBirth) >
                                                    0)
                                                ? true
                                                : false,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Umur: ',
                                                style: MyFonts.customTextStyle(
                                                  12,
                                                  FontWeight.w500,
                                                  MyColor.whiteColor,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${registerFormProvider.calculateAge(registerFormProvider.selectedDateOfBirth)} Tahun',
                                                style: MyFonts.customTextStyle(
                                                  12,
                                                  FontWeight.bold,
                                                  MyColor.whiteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jenis Kelamin',
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.whiteColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              // height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: MyColor.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  RadioListTile<Gender>(
                                    title: Text(
                                      'Laki-Laki',
                                      style: MyFonts.customTextStyle(
                                        15,
                                        FontWeight.w500,
                                        MyColor.greyText,
                                      ),
                                    ),
                                    value: Gender.Male,
                                    dense: true,
                                    groupValue:
                                        registerFormProvider.selectedGender,
                                    activeColor: MyColor.primaryColor,
                                    onChanged: (Gender? value) {
                                      registerFormProvider.selectedGender =
                                          value!;
                                    },
                                  ),
                                  RadioListTile<Gender>(
                                    title: Text(
                                      'Perempuan',
                                      style: MyFonts.customTextStyle(
                                        15,
                                        FontWeight.w500,
                                        MyColor.greyText,
                                      ),
                                    ),
                                    value: Gender.Female,
                                    dense: true,
                                    activeColor: MyColor.primaryColor,
                                    groupValue:
                                        registerFormProvider.selectedGender,
                                    onChanged: (Gender? value) {
                                      registerFormProvider.selectedGender =
                                          value!;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<LoginProvider>(builder: (context, value, _) {
            if (value.userId == null) {
              value.loadUserId();
              return CircularProgressIndicator();
            } else {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: ButtonWidget(
                  title: 'Kirim Data',
                  color: (registerFormProvider.addressController.text == '' &&
                          registerFormProvider.phoneNumberController.text ==
                              '' &&
                          registerFormProvider.placeOfBirthController.text ==
                              '')
                      ? null
                      : MyColor.primaryColor,
                  onPressed: () {
                    var data = registerFormProvider.selectedGender;
                    var dataGender = data.toString().split('.').last;
                    registerFormProvider.onSubmit(
                      {
                        "address": registerFormProvider.addressController.text,
                        "phone_number":
                            registerFormProvider.phoneNumberController.text,
                        "gender":
                            (dataGender == 'Male') ? 'Laki-Laki' : 'Perempuan',
                        "age": registerFormProvider.calculateAge(
                            registerFormProvider.selectedDateOfBirth),
                        "birth_place":
                            registerFormProvider.placeOfBirthController.text,
                        "birth_date":
                            registerFormProvider.selectedDateOfBirth.toString(),
                      },
                      context,
                      (token == null) ? '' : token!,
                      value.userId!,
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
