import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController _newAddress = TextEditingController();
  TextEditingController _newPhoneNumber = TextEditingController();
  TextEditingController _newGender = TextEditingController();
  TextEditingController _newAge = TextEditingController();
  TextEditingController _newBirthPlace = TextEditingController();
  TextEditingController _newBirthDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Edit Profile',
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextFieldWidget(
              hintText: 'Address',
              obscureText: false,
              controller: _newAddress,
              textColor: MyColor.greyText,
              suffixIcon: Icon(
                Icons.home_rounded,
              ),
            ),
            SizedBox(height: 12),
            TextFieldWidget(
              hintText: 'Phone Number',
              obscureText: false,
              controller: _newAddress,
              textColor: MyColor.greyText,
              suffixIcon: Icon(
                Icons.home_rounded,
              ),
            ),
            SizedBox(height: 12),
            TextFieldWidget(
              hintText: 'Gender',
              obscureText: false,
              controller: _newAddress,
              textColor: MyColor.greyText,
              suffixIcon: Icon(
                Icons.home_rounded,
              ),
            ),
            SizedBox(height: 12),
            TextFieldWidget(
              hintText: 'Age',
              obscureText: false,
              controller: _newAddress,
              textColor: MyColor.greyText,
              suffixIcon: Icon(
                Icons.home_rounded,
              ),
            ),
            SizedBox(height: 12),
            TextFieldWidget(
              hintText: 'Birth Place',
              obscureText: false,
              controller: _newAddress,
              textColor: MyColor.greyText,
              suffixIcon: Icon(
                Icons.home_rounded,
              ),
            ),
            SizedBox(height: 12),
            TextFieldWidget(
              hintText: 'Birth Date',
              obscureText: false,
              controller: _newAddress,
              textColor: MyColor.greyText,
              suffixIcon: Icon(
                Icons.home_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
