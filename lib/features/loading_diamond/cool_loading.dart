import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CoolLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCube(
      color: Colors.blue, // Sesuaikan dengan warna yang Anda inginkan
      size: 50.0, // Sesuaikan dengan ukuran yang Anda inginkan
    );
  }
}
