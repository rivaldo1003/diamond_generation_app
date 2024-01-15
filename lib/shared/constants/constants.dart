class ApiConstants {
  static const baseUrl = 'https://gsjasungaikehidupan.com/api';
  static const baseUrlImage = 'https://gsjasungaikehidupan.com/storage';

  static const loginUrl = baseUrl + '/login';
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
}
