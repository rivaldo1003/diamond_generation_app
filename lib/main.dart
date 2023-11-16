import 'package:diamond_generation_app/core/repositories/user_repository.dart';
import 'package:diamond_generation_app/core/repositories/wpda_repository.dart';
import 'package:diamond_generation_app/core/services/api_services.dart';
import 'package:diamond_generation_app/core/usecases/get_user_usecase.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/data/providers/bottom_nav_bar_provider.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/home/data/providers/home_provider.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/features/register/data/providers/register_provider.dart';
import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/features/splash_screen/presentation/splash_screen.dart';
import 'package:diamond_generation_app/features/view_all_data_users/data/providers/view_all_data_user_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomNaviBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchUserProvider(
            getUserUsecase: GetUserUsecase(
              userRepository: UserRepositoryImpl(
                apiService: ApiService(
                  urlApi: ApiConstants.getAllUser,
                ),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) => WpdaProvider(
                    getUserUsecase: GetUserUsecase(
                        userRepository: UserRepositoryImpl(
                            apiService: ApiService(
                  urlApi: ApiConstants.createWpdaUrl,
                ))))),
        ChangeNotifierProvider(
          create: (context) => RegisterFormProvider(
              getUserUsecase: GetUserUsecase(
                  userRepository: UserRepositoryImpl(
                      apiService: ApiService(
            urlApi: ApiConstants.submitDataUserUrl,
          )))),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterProvider(
            getUserUsecase: GetUserUsecase(
              userRepository: UserRepositoryImpl(
                apiService: ApiService(urlApi: ApiConstants.registerUrl),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(
            getUserUsecase: GetUserUsecase(
              userRepository: UserRepositoryImpl(
                apiService: ApiService(
                  urlApi: ApiConstants.loginUrl,
                ),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(
            userRepository: UserRepositoryImpl(
              apiService: ApiService(
                urlApi: ApiConstants.newCreation1Url,
              ),
            ),
          ),
        ),
        Provider(
            create: (context) => GetUserUsecase(
                    userRepository: UserRepositoryImpl(
                        apiService: ApiService(
                  urlApi: ApiConstants.newCreation1Url,
                ))))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: CustomTheme.darkTheme,
      ),
    );
  }
}
