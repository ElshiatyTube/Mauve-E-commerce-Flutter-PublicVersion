import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/cart/cart_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_cubit.dart';
import 'package:flutterecom/cubit/user_address/user_address_cubit.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/presentaion/layouts/home_layout.dart';
import 'package:flutterecom/presentaion/modules/cart/cart_screen.dart';
import 'package:flutterecom/presentaion/modules/chat/chat_screen.dart';
import 'package:flutterecom/presentaion/modules/contact/contact_screen.dart';
import 'package:flutterecom/presentaion/modules/login/login_screen.dart';
import 'package:flutterecom/presentaion/modules/onboard/onboard_screen.dart';
import 'package:flutterecom/presentaion/modules/otp/otp_screen.dart';
import 'package:flutterecom/presentaion/modules/product_details/product_details_screen.dart';
import 'package:flutterecom/presentaion/modules/register/register_screen.dart';
import 'package:flutterecom/presentaion/modules/splash/splash_screen.dart';
import 'package:flutterecom/presentaion/modules/user_address/user_address_screen.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splashPath:
        return MaterialPageRoute(
         builder:(_) {
           bool onBoarding = CacheHelper.getBool(key: 'onboard');
           String uId = CacheHelper.getString(key: 'uId');
           if(onBoarding){
             if(uId != ''){
               return SplashScreen(startScreen: HomeLayout(),);
             }else{
               return SplashScreen(startScreen: LoginScreen(),);
             }
           }else{
             return const SplashScreen(startScreen: OnboardScreen(),);
           }
         },
       );
      case loginPath:
        return MaterialPageRoute(
          builder:(_) =>  LoginScreen(),
        );
      case registerPath:
        return MaterialPageRoute(
          builder:(_) =>  RegisterScreen(),
        );
      case otpPath:
        final phone = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder:(_) =>  OtpScreen(phoneNumber: phone,),
        );
      case homeLayoutPath:
        return MaterialPageRoute(
          builder:(_) =>  HomeLayout(),
        );
      case productDetailsPath:
        final productItem = routeSettings.arguments as ProductModel;
        return MaterialPageRoute(
          builder:(_) =>  BlocProvider(create: (_) => ProductDetailsCubit(),child: ProductDetailsScreen(productItem: productItem,)),
        );
      case chatPath:
        return MaterialPageRoute(
          builder:(_) =>  const ChatScreen(),
        );
      case userAddressPath:
        return MaterialPageRoute(
          builder:(_) =>  const UserAddressScreen(),
        );
      case cartPath:
        return MaterialPageRoute(
          builder:(_) =>  const CartScreen(),
        );
      case contactPath:
        return MaterialPageRoute(
          builder:(_) =>  ContactScreen(),
        );


    }
  }

}
