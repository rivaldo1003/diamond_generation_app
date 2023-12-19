import 'package:flutter/material.dart';

class ProfilePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.15,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 16,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
