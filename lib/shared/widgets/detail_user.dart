import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/features/whatsapp_launcher/presentation/whatsapp_launcher.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailUser extends StatefulWidget {
  final Widget iconData;
  final String title;
  final String value;
  final bool? readOnly;
  final Widget? rightIcon;
  TextEditingController? controller;
  TextInputType? keyboardType;

  DetailUser({
    super.key,
    required this.iconData,
    required this.title,
    required this.value,
    this.readOnly,
    this.controller,
    this.keyboardType,
    this.rightIcon,
  });

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
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
    widget.controller!.text = widget.value;
  }

  final _keyForm = GlobalKey<FormState>();

  String _tempValue = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller!.text = widget.value;
        });
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
                    Form(
                      // key: _keyForm,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: (widget.keyboardType == null)
                                ? TextInputType.none
                                : widget.keyboardType,
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
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
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
      child: Container(
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
                    widget.iconData,
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: MyFonts.customTextStyle(
                          12,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.value,
                          overflow: TextOverflow.ellipsis,
                          style: MyFonts.customTextStyle(
                            12,
                            FontWeight.w500,
                            MyColor.greyText,
                          ),
                        ),
                      ),
                      (widget.title == 'No Telepon')
                          ? Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    WhatsAppLauncher.openWhatsApp(
                                        phoneNumber: "+62 ${widget.value} ",
                                        message:
                                            "Ayo, jangan lupa WPDA. Terus bertumbuh ya");
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/whatsapp.svg',
                                    height: 24,
                                    width: 24,
                                  )),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
