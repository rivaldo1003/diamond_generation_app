class ApiConstants {
  static const baseUrl =
      'https://ae54-158-140-167-54.ngrok-free.app/diamond-generation-service/public/api';
  static const baseUrlImage =
      'https://ae54-158-140-167-54.ngrok-free.app/diamond-generation-service/public/storage';

  static const loginUrl = baseUrl + '/login';
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

  // OLD API URL
  static const newCreation1Url = baseUrl + 'new_creation_1.php';
  static const newCreation2Url = baseUrl + 'new_creation_2.php';
  static const lightUrl = baseUrl + 'light.php';
  static const getUserProfileUrl = baseUrl + 'read_user_profile.php';
  static const uploadImageUrl = baseUrl + 'upload_image.php';
  static const readImageUrl = baseUrl + 'read_image.php';
}
