import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: KeyboardDetector(),
  ));
}

class KeyboardDetector extends StatefulWidget {
  @override
  _KeyboardDetectorState createState() => _KeyboardDetectorState();
}

class _KeyboardDetectorState extends State<KeyboardDetector> {
  bool isKeyboardVisible = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    EdgeInsets viewInsets = mediaQueryData.viewInsets;
    double keyboardHeight = viewInsets.bottom;

    isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Keyboard Detector'),
      ),
      body: GestureDetector(
        onTap: () {
          // Menutup keyboard saat pengguna mengetuk di area lain
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Enter Text',
                  ),
                  onTap: () {
                    setState(() {
                      isKeyboardVisible = true;
                    });
                  },
                  onChanged: (value) {
                    // Your logic when text changes
                  },
                ),
              ),
              SizedBox(height: 20),
              if (isKeyboardVisible) ...[
                Text(
                  'Keyboard is visible!',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
