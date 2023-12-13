import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenUtil {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferencesManager.keyToken);
  }
}
