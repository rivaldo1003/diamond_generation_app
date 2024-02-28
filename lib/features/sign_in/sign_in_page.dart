// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'app banner/app_banner.dart';
// import 'app banner/banner_item.dart';
// import 'app banner/indicator.dart';

// class SignInPage extends StatefulWidget {
//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }

// class _SignInPageState extends State<SignInPage> {
//   final viewModel = SignInViewModel();

//   Future<void> _handleGoogleSignIn() async {
//     _showLoadingDialog();
//     final response = await viewModel.handleSignIn();
//     response.fold((e) {
//       Navigator.of(context).pop();
//       showErrorSnackBar('Error', e.toString());
//     }, (r) {
//       Navigator.of(context).pop();
//       _navigateToNextPage();
//     });
//   }

//   void _showLoadingDialog() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return Center(
//             child: SizedBox(
//               width: 22,
//               height: 22,
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//               ),
//             ),
//           );
//         });
//   }

//   Future<void> _navigateToNextPage() async {
//     final pref = await SharedPreferences.getInstance();
//     final deviceId = pref.getString(KEY_LAST_CONNECTED_DEVICE);
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) {
//         if (deviceId != null) {
//           return DeviceScreen(deviceId: deviceId);
//         }
//         return MainBottomNavigationPage();
//       }),
//       (route) => false,
//     );
//   }

//   var _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle.light.copyWith(
//         statusBarBrightness: Brightness.dark,
//       ),
//     );
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/images/dark_bg3.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             top: MediaQuery.of(context).size.height / 5,
//             child: Column(
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height / 2.3,
//                   child: PageView.builder(
//                     onPageChanged: (index) {
//                       setState(() {
//                         _selectedIndex = index;
//                       });
//                     },
//                     itemCount: appBannerList.length,
//                     itemBuilder: (context, index) {
//                       var banner = appBannerList[index];
//                       var _scale = _selectedIndex == index ? 1.0 : 0.8;
//                       return TweenAnimationBuilder(
//                         tween: Tween(
//                           begin: _scale,
//                           end: _scale,
//                         ),
//                         curve: Curves.ease,
//                         duration: Duration(milliseconds: 350),
//                         builder: (context, value, child) {
//                           return Transform.scale(
//                             scale: value,
//                             child: child,
//                           );
//                         },
//                         child: BannerItem(
//                           appBanner: banner,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ...List.generate(appBannerList.length, (index) {
//                       return Indicator(
//                         isActive: _selectedIndex == index ? true : false,
//                       );
//                     })
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: EdgeInsets.only(
//                 left: 16,
//                 top: 0,
//                 bottom: 40,
//                 right: 16,
//               ),
//               width: MediaQuery.of(context).size.width,
//               child: SingleChildScrollView(
//                 child: Column(
//                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     buildSignInProvider(
//                       context,
//                       titleProvider: 'Google',
//                       Imgprovider: 'assets/icons/google.svg',
//                       onTap: () async {
//                         _handleGoogleSignIn();
//                       },
//                     ),
//                     SizedBox(height: 24),
//                     // buildSignInProvider(
//                     //   context,
//                     //   titleProvider: 'Facebook',
//                     //   Imgprovider: 'assets/icons/facebook.svg',
//                     //   onTap: () {},
//                     // ),
//                     // SizedBox(height: 24),
//                     // buildSignInProvider(
//                     //   context,
//                     //   titleProvider: 'Apple',
//                     //   Imgprovider: 'assets/icons/apple.svg',
//                     //   onTap: () {},
//                     // ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildSignInProvider(
//     BuildContext context, {
//     required String titleProvider,
//     required String Imgprovider,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       alignment: Alignment.center,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Material(
//         borderRadius: BorderRadius.circular(25),
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(24),
//           splashColor: brownColor,
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   '${Imgprovider}',
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'Continue with ${titleProvider}',
//                   style: GoogleFonts.montserrat(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 17,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
