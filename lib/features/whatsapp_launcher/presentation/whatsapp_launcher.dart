import 'package:url_launcher/url_launcher.dart';

class WhatsAppLauncher {
  static Future<void> openWhatsApp({
    required String phoneNumber,
    String message = "",
  }) async {
    try {
      String url = "https://wa.me/+62$phoneNumber/?text=${Uri.parse(message)}";
      print(phoneNumber);
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }
}
