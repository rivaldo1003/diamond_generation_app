class ApiConstants {
  // static const baseUrl = 'http://192.168.110.85/diamond_generation/';
  // static const loginUrl = baseUrl + 'login.php';

  static const baseUrl =
      'http://192.168.110.85/diamond-generation-service/public/api';

  static const loginUrl = baseUrl + '/login';
  static const readUserProfileByIdUrl = baseUrl + '/users';
  static const getAllWpdaUrl = baseUrl + '/wpda';
  static const historyWpdaUrl = baseUrl + '/wpda/history';
  static const createWpdaUrl = baseUrl + '/wpda/create';
  static const editWpdaUrl = baseUrl + '/wpda/update';
  static const deleteWpdaUrl = baseUrl + '/wpda/delete';

  static const newCreation1Url = baseUrl + 'new_creation_1.php';
  static const newCreation2Url = baseUrl + 'new_creation_2.php';
  static const lightUrl = baseUrl + 'light.php';
  static const registerUrl = baseUrl + 'register.php';
  static const submitDataUserUrl = baseUrl + 'user_profile.php';
  static const getUserProfileUrl = baseUrl + 'read_user_profile.php';
  static const getAllUser = baseUrl + 'read_all_users.php';
  static const approveUserUrl = baseUrl + 'approved.php';
  static const deleteUserUrl = baseUrl + 'delete_user.php';
  static const uploadImageUrl = baseUrl + 'upload_image.php';
  static const readImageUrl = baseUrl + 'read_image.php';
}
