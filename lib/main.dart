import 'package:diamond_generation_app/core/repositories/user_repository.dart';
import 'package:diamond_generation_app/core/repositories/wpda_repository.dart';
import 'package:diamond_generation_app/core/services/users/user_api.dart';
import 'package:diamond_generation_app/core/services/wpda/wpda_api.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/data/providers/bottom_nav_bar_provider.dart';
import 'package:diamond_generation_app/features/comment/data/comment_provider.dart';
import 'package:diamond_generation_app/features/comment/presentation/comment_tes.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/data/detail_history_provider.dart';
import 'package:diamond_generation_app/features/history_wpda/data/history_provider.dart';
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
import 'package:diamond_generation_app/shared/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          create: (context) => AddWpdaWProvider(),
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
