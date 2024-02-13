import 'package:diamond_generation_app/core/repositories/user_repository.dart';
import 'package:diamond_generation_app/core/repositories/wpda_repository.dart';
import 'package:diamond_generation_app/core/services/users/user_api.dart';
import 'package:diamond_generation_app/core/services/wpda/wpda_api.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/data/providers/bottom_nav_bar_provider.dart';
import 'package:diamond_generation_app/features/comment/data/comment_provider.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/data/detail_history_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/data/history_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/data/today_wpda.dart';
import 'package:diamond_generation_app/features/home/data/providers/home_provider.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/features/register/data/providers/register_provider.dart';
import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/features/splash_screen/presentation/splash_screen.dart';
import 'package:diamond_generation_app/features/verified_email/data/providers/verified_email_provider.dart';
import 'package:diamond_generation_app/features/view_all_data_users/data/providers/view_all_data_user_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/bible_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/edit_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/like_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  FirebaseMessaging.onBackgroundMessage((message) {
    // Handle background message here
    return Future<void>.value();
  });

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("ae235573-b52c-44a5-b2c3-23d9de4232fa");
  OneSignal.Notifications.requestPermission(true);
  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

  // Menunggu hingga mendapatkan device token sebelum menyimpannya
  String? deviceToken;
  OneSignal.User.pushSubscription.addObserver((state) async {
    print('Output :${OneSignal.User.pushSubscription.optedIn}');
    print('Output :${OneSignal.User.pushSubscription.id}');
    deviceToken = OneSignal.User.pushSubscription.id;
    print('Output :${OneSignal.User.pushSubscription.token}');
    print(state.current.jsonRepresentation());

    // Simpan device token setelah diperoleh
    if (deviceToken != null && deviceToken!.isNotEmpty) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(SharedPreferencesManager.keyDeviceToken, deviceToken!);
      print('DEVICEE TOKENNNNNN : $deviceToken');
    }
  });

  String? _debugLabelString;

  OneSignal.Notifications.addClickListener((event) {
    print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
    _debugLabelString =
        "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  });

  await initializeDateFormatting('id_ID', null);
  timeago.setLocaleMessages('id', timeago.IdMessages());
  runApp(MyApp());
}

// class PushNotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<String?> getDeviceToken() async {
//     try {
//       // Request permission for accessing the device token (if not already granted)
//       await _firebaseMessaging.requestPermission();

//       // Get the device token
//       String? deviceToken = await _firebaseMessaging.getToken();

//       return deviceToken;
//     } catch (e) {
//       print('Error getting device token: $e');
//       return null;
//     }
//   }
// }

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

Future openNotif() async {
  OneSignal.InAppMessages.addClickListener((event) {
    print(
        "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}");
  });
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VerifiedEmailProvider(
              getUserUsecase: GetUserUsecase(
                  userRepository: UserRepositoryImpl(
                      userApi: UserApi(
            urlApi: ApiConstants.verifyUserUrl,
          )))),
        ),
        ChangeNotifierProvider(
          create: (context) => TodayWpdaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNaviBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LikeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BibleProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailHistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewAllDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(
              getUserUsecase: GetUserUsecase(
                  userRepository: UserRepositoryImpl(
                      userApi: UserApi(urlApi: ApiConstants.updateProfile)))),
        ),
        ChangeNotifierProvider(
          create: (context) => AddWpdaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchUserProvider(
            getUserUsecase: GetUserUsecase(
              userRepository: UserRepositoryImpl(
                userApi: UserApi(
                  urlApi: ApiConstants.getAllUser,
                ),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EditWpdaProvider(
            getWpdaUsecase: GetWpdaUsecase(
              wpdaRepository: WpdaRepositoryImpl(
                wpdaApi: WpdaApi(urlApi: ApiConstants.editWpdaUrl),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) => WpdaProvider(
                    getWpdaUsecase: GetWpdaUsecase(
                        wpdaRepository: WpdaRepositoryImpl(
                            wpdaApi: WpdaApi(
                  urlApi: ApiConstants.createWpdaUrl,
                ))))),
        ChangeNotifierProvider(
          create: (context) => RegisterFormProvider(
              getUserUsecase: GetUserUsecase(
                  userRepository: UserRepositoryImpl(
                      userApi: UserApi(
            urlApi: ApiConstants.submitDataUserUrl,
          )))),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterProvider(
            getUserUsecase: GetUserUsecase(
              userRepository: UserRepositoryImpl(
                userApi: UserApi(urlApi: ApiConstants.registerUrl),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(
            getUserUsecase: GetUserUsecase(
              userRepository: UserRepositoryImpl(
                userApi: UserApi(
                  urlApi: ApiConstants.loginUrl,
                ),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(
            userRepository: UserRepositoryImpl(
              userApi: UserApi(
                urlApi: ApiConstants.newCreation1Url,
              ),
            ),
          ),
        ),
        Provider(
            create: (context) => GetUserUsecase(
                    userRepository: UserRepositoryImpl(
                        userApi: UserApi(
                  urlApi: ApiConstants.newCreation1Url,
                )))),
        Provider(
            create: (context) => GetWpdaUsecase(
                    wpdaRepository: WpdaRepositoryImpl(
                        wpdaApi: WpdaApi(
                  urlApi: ApiConstants.getAllWpdaUrl,
                )))),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: CustomTheme.darkTheme,
      ),
    );
  }
}
