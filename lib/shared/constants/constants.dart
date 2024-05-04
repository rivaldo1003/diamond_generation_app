class ApiConstants {
  static const baseUrl = 'https://gsjasungaikehidupan.com/api';
  static const baseUrlImage = 'https://gsjasungaikehidupan.com/storage';
  static const ONE_SIGNAL_REST_API_KEY =
      'OGRhZTY2M2YtMDNjOC00YTU2LTgyYzEtNzY4YzA2OWZiMDk0';

  static const loginUrl = baseUrl + '/login';
  static const logoutUrl = baseUrl + '/user/logout';
  static const loginGoogleUrl = baseUrl + '/google-login';
  static const registerUrl = baseUrl + '/register';
  static const readUserProfileByIdUrl = baseUrl + '/users';
  static const getAllWpdaUrl = baseUrl + '/wpda';
  static const historyWpdaUrl = baseUrl + '/wpda/history';
  static const createWpdaUrl = baseUrl + '/wpda/create';
  static const editWpdaUrl = baseUrl + '/wpda/update';
  static const deleteWpdaUrl = baseUrl + '/wpda/delete';
  static const getAllUser = baseUrl + '/users/all';
  static const approveUserUrl = baseUrl + '/approve';
  static const submitDataUserUrl = baseUrl + '/profile';
  static const deleteUserUrl = baseUrl + '/user/delete';
  static const updateProfile = baseUrl + '/profile/update';
  static const getTotalNewUsers = baseUrl + '/total-new-users';
  static const getMonthlyDataForAllUsers = baseUrl + '/users/monthly-data';
  static const verifyUserUrl = baseUrl + '/verify-user';
  static const commentWpda = baseUrl + '/comments';
  static const deleteCommentWpda = baseUrl + '/comments/delete';
  static const userGenderTotal = baseUrl + '/user-gender-total';
  static const updateFullName = baseUrl + '/update-full-name';
  static const saveSubsriptionId = baseUrl + '/save-subscription-id';
  static const verifyEmail = baseUrl + '/send-verify-mail';
  static const forgetPassword = baseUrl + '/forget-password';
  static const getWpdaObedEdom = baseUrl + '/wpda/obed-edom';
  static const notification = 'https://onesignal.com/api/v1/notifications';

  // OLD API URL
  static const newCreation1Url = baseUrl + 'new_creation_1.php';
  static const newCreation2Url = baseUrl + 'new_creation_2.php';
  static const lightUrl = baseUrl + 'light.php';
  static const getUserProfileUrl = baseUrl + 'read_user_profile.php';
  static const uploadImageUrl = baseUrl + 'upload_image.php';
  static const readImageUrl = baseUrl + 'read_image.php';
}
