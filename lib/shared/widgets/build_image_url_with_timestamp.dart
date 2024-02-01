import 'package:diamond_generation_app/shared/constants/constants.dart';

String buildImageUrlWithStaticTimestamp(String? profilePicture) {
  if (profilePicture != null &&
      profilePicture.isNotEmpty &&
      profilePicture != 'null') {
    // Tambahkan timestamp sebagai parameter query string
    return Uri.https(
            'gsjasungaikehidupan.com',
            '/storage/profile_pictures/$profilePicture',
            {'timestamp': DateTime.now().millisecondsSinceEpoch.toString()})
        .toString();
  } else {
    return "${ApiConstants.baseUrlImage}/profile_pictures/profile_pictures/dummy.jpg";
  }
}
