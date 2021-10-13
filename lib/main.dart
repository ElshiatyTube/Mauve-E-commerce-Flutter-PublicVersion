import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/cart/cart_cubit.dart';
import 'package:flutterecom/presentaion/dialogs/interner_check_dialog.dart';
import 'package:flutterecom/shared/bloc_observer.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:flutterecom/shared/network/local/hive/employee.dart';
import 'package:flutterecom/shared/route/routes.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_context/one_context.dart';

import 'cubit/auth/auth_cubit.dart';
import 'cubit/check_connection/check_connection_cubit.dart';
import 'cubit/check_connection/check_connection_state.dart';
import 'cubit/home_layout/home_layout_cubit.dart';
import 'cubit/product_details/product_details_cubit.dart';
import 'cubit/user_address/user_address_cubit.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  await Hive.initFlutter();
  Bloc.observer = MyBlocObserver();


  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employee');



/*  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (BuildContext context)=>EasyLocalization(
        path: 'resources/languages',
        saveLocale: true,
        supportedLocales:const [ Locale('en', 'EN'), Locale('ar', 'AR')],
        child: OneNotification(builder: (_, __) =>  MyApp(appRouter: AppRouter(),) )
    ),
  ));*/

  runApp(EasyLocalization(
      path: 'resources/languages',
      saveLocale: true,
      supportedLocales:const [Locale('en', 'EN'), Locale('ar', 'AR')],
      child: OneNotification(builder: (_, __) =>  MyApp(appRouter: AppRouter(),) )
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  MyApp({Key? key,required this.appRouter}) : super(key: key,);

  @override
  Widget build(BuildContext context) {

    ThemeData lightTheme = ThemeData(
      buttonTheme: const ButtonThemeData(
        buttonColor: defaultColor,
        textTheme: ButtonTextTheme.primary,
      ),
      primarySwatch: defaultColor,
      scaffoldBackgroundColor: MyColors.scaffoldBackgroundColorMain,
      canvasColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          fontFamily: context.locale.toString().contains('ar') ? 'ArabicText' : 'EnFont',

        ),
        titleSpacing: 19.0,
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: MyColors.scaffoldBackgroundColorMain,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: MyColors.scaffoldBackgroundColorMain,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: defaultColor,
          unselectedItemColor: Colors.grey,
          elevation: 20.0,
          backgroundColor: Colors.white
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontFamily: context.locale.toString().contains('ar') ? 'ArabicText' : 'EnFont',
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        subtitle1: TextStyle(
          fontFamily: context.locale.toString().contains('ar') ? 'ArabicText' : 'EnFont',
          fontSize: 13.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          height: 1.3,
        ),
      ),
      fontFamily:context.locale.toString().contains('ar') ? 'ArabicText' : 'EnFont',
    );

    return MultiBlocProvider(
     providers: [
       BlocProvider(create: (_) => CheckConnectionCubit()..initializeConnectivity(),),
       BlocProvider(create: (_) => AuthCubit(),),
       BlocProvider(create: (_)=> HomeLayoutCubit(_)..initFirebaseBackgroundFCM(_)..getBackgroundFcmData()..getInfo()..getCategoryList(),),
       BlocProvider(create: (_) => CartCubit(),),
       BlocProvider(create: (_) => UserAddressCubit(),),
     ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CheckConnectionCubit,CheckConnectionStates>(
              listener: (context,state){
                if(state is InternetDisconnected){
                  CheckConnectionCubit.get(context).isNetDialogShow = true;
                  print('InternetDisconnected');
                  Future.delayed(const Duration(milliseconds: 500), () { //0.5 sec
                    OneContext().showDialog(
                      barrierDismissible: false ,
                      builder: (context) => const NoInternetDialog(canDismiss: false),
                    );
                  });

                }
                if(state is InternetConnected){
                  if(CheckConnectionCubit.get(context).isNetDialogShow)
                  {
                    print('InternetConnected');
                    OneContext().popDialog();
                    CheckConnectionCubit.get(context).isNetDialogShow = false;
                  }
                }
              }
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          builder: OneContext().builder,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: lightTheme,
          onGenerateRoute: appRouter.onGenerateRoute,
        ),
      ),

    );
  }
}



