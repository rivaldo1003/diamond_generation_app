import 'package:url_launcher/url_launcher.dart';

class WhatsAppLauncher {
  static Future<void> openWhatsApp(
      {required String phoneNumber, String message = ""}) async {
    try {
      String url = "https://wa.me/$phoneNumber/?text=${Uri.parse(message)}";
      await launch(url,
          forceSafariVC: false, forceWebView: false, enableJavaScript: true);
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }
}
