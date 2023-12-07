import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  final String token;

  RegisterForm({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final registerFormProvider = Provider.of<RegisterFormProvider>(context);

    print('DARI REGISTER FORM :${token}');
    return Scaffold(
      appBar: AppBarWidget(title: 'Enter Personal Information'),
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
                                hintText: 'Full Name',
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
                          hintText: 'Address',
                          suffixIcon: Icon(Icons.location_on),
                          obscureText: false,
                          focusNode: registerFormProvider.addressFocusNode,
                          controller: registerFormProvider.addressController,
                          errorText:
                              registerFormProvider.showRequiredMessageAddress
                                  ? 'Address Required'
                                  : null,
                          onChanged: (value) {
                            registerFormProvider.showRequiredMessageAddress =
                                false;
                            registerFormProvider.notifyListeners();
                          },
                        ),
                        SizedBox(height: 12),
                        TextFieldWidget(
                          hintText: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          suffixIcon: Icon(Icons.phone),
                          obscureText: false,
                          focusNode: registerFormProvider.phoneNumberFocusNode,
                          controller:
                              registerFormProvider.phoneNumberController,
                          errorText: registerFormProvider
                                  .showRequiredMessagePhoneNumber
                              ? 'Phone Number Required'
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
                              'Place and Date of Birth',
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
                                    hintText: 'Place of Birth',
                                    obscureText: false,
                                    focusNode: registerFormProvider
                                        .placeOfBirthFocusNode,
                                    controller: registerFormProvider
                                        .placeOfBirthController,
                                    errorText: registerFormProvider
                                            .showRequiredMessagePlaceOfBirth
                                        ? 'Place of Birth Required'
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
                                            Text(
                                              'Your Age: ',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.w500,
                                                MyColor.whiteColor,
                                              ),
                                            ),
                                            Text(
                                              '${registerFormProvider.calculateAge(registerFormProvider.selectedDateOfBirth)} Years',
                                              style: MyFonts.customTextStyle(
                                                14,
                                                FontWeight.bold,
                                                MyColor.whiteColor,
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
                              'Gender',
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.whiteColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: MyColor.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<Gender>(
                                      title: Text(
                                        'Male',
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
                                  ),
                                  Expanded(
                                    child: RadioListTile<Gender>(
                                      title: Text(
                                        'Female',
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
                  title: 'Submit',
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
                    registerFormProvider.onSubmit({
                      "user_id": value.userId,
                      "address": registerFormProvider.addressController.text,
                      "phone_number":
                          registerFormProvider.phoneNumberController.text,
                      "gender": dataGender,
                      "age": registerFormProvider.calculateAge(
                          registerFormProvider.selectedDateOfBirth),
                      "birth_place":
                          registerFormProvider.placeOfBirthController.text,
                      "birth_date":
                          registerFormProvider.selectedDateOfBirth.toString(),
                    }, context);
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
