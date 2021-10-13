import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/data/api/category_api.dart';
import 'package:flutterecom/data/api/products_api.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/data/models/messages_model.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/data/models/token_model.dart';
import 'package:flutterecom/data/models/user_model.dart';
import 'package:flutterecom/data/repo/category_repo.dart';
import 'package:flutterecom/data/repo/product_repo.dart';
import 'package:flutterecom/presentaion/modules/account/account_screen.dart';
import 'package:flutterecom/presentaion/modules/categories/categories_screen.dart';
import 'package:flutterecom/presentaion/modules/home/home_screen.dart';
import 'package:flutterecom/presentaion/modules/orders/orders_screen.dart';
import 'package:flutterecom/presentaion/modules/products/products_screen.dart';
import 'package:flutterecom/services/fcm/firebase_notification_handler.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:ntp/ntp.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_layout_state.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutStates>{
  BuildContext context;
  HomeLayoutCubit(this.context) : super(HomeLayoutInitState()){
    if(CacheHelper.getString(key: 'uId')!=''){
      getUserData(uid: CacheHelper.getString(key: 'uId'));
    }
  }

  static HomeLayoutCubit get(context) => BlocProvider.of(context);


  void updateToken(BuildContext context) {
      FirebaseMessaging.instance.getToken().then((token) {
        TokenModel tokenModel = TokenModel(AuthCubit.get(context).userModel.phone, token!, false, false);
        FirebaseFirestore.instance
            .collection(TOKEN_COLLECTION)
            .doc(CacheHelper.getString(key: 'uId'))
            .set(tokenModel.toMap())
            .then((value) {
          print('GetUserDtaLogin & update TokenLogin');

          emit(UpdateMainUserTokenStateSuccess());
        }).catchError((onError) {
          print(onError.toString());
          emit(UpdateMainUserTokenStateFailed());
        });
      });
  }

  FirebaseNotifications firebaseNotifications= FirebaseNotifications();

  void initFirebaseBackgroundFCM(context)
  {
    firebaseNotifications.setUpFirebase(context);
    emit(InitFirebaseBackgroundFCMSucess());
  }
  void getBackgroundFcmData() async
  {
    await CacheHelper.init();
    String backgroundData  = CacheHelper.getString(key: 'required_string');
    emit(GetNotifyDataBackgroundSuccess(backgroundData));
  }


  void getUserData({
    required String uid,
  })
  {
        FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .doc(uid)
            .get()
            .then((value) {
          if(value.exists)
          {
            AuthCubit.get(context).userModel = UserModel.fromJson(value.data()!);
            print('GetUserDta');
            updateToken(context);
          }else{
            emit(UpdateMainUserTokenStateNotLogin());
          }
        }).catchError((onError){
          emit(GetUserDataFailedState(onError.toString()));
        });

  }


  int currentIndicator = 0;
  void homeSliderIndicator(int newIndex){
    currentIndicator = newIndex;
    emit(SliderIndicatorChange());
  }

  int currentIndex = 0;

  List<Widget> bottomScreens = [
     HomeScreen(),
     CategoriesScreen(),
     OrderScreen(),
     AccountScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }



  List<CategoriesModel> categoryList=[];

  void getCategoryList()
  {
    CategoryRepo categoryRepo = CategoryRepo(CategoryApi(categoryList: categoryList));
    emit(LoadingCategoriesState());

    categoryRepo.getCategories().then((value) {
      categoryList = value;
      emit(SuccessCategoriesState());
    }).catchError((onError){
      emit(FailedCategoriesState(onError.toString()));
    });
  }


  late CategoriesModel selectedCategory;

  void navigateToProductListByCategory({required CategoriesModel categoryItem}) {
    emit(NavigateToProductListByCategoryState(categoryItem));
  }
  void navigateToCategoryList() {
    emit(NavigateToToCategoryListState());
  }

 late List<ProductModel> productList;

  void getProductsByCategoryMenuId({required CategoriesModel categoriesItem}) {
    productList=[];
    ProductsRepo productsRepo = ProductsRepo(ProductsApi(productList: productList, selectedCategoryItem: categoriesItem));
    emit(LoadingProductsState());

    productsRepo.getProducts().then((value) {
      productList = value;
      selectedCategory = categoriesItem; //Late use
      emit(SuccessProductsState());
    }).catchError((onError){
      emit(FailedProductsState(onError.toString()));
    });
  }

  //Settings Screen

  String welcomeText = 'Welcome';
  void getWelcomeText(DateTime dateTime) async {
    DateTime now = dateTime.toLocal();
    int offset = await NTP.getNtpOffset(localTime: now); //Sync time with server
    DateTime syncTime = now.add(Duration(milliseconds: offset));
    var timeNow = syncTime.hour;

    if (timeNow <= 12) { //12
      welcomeText =  'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) { //12 - 4 pm
      welcomeText = 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) { //4 - 9 pm
      welcomeText = 'Good Evening';
    } else { // 9 -12 pm
      welcomeText = 'Good Night';
    }

    emit(WelcomeState());
  }

  String appleId='',hotline='',whatsapp='',complaints='',about='',aboutAr='';
  late int androidVersion,iosVersion;
  bool open=true,inviteBtn=false;
  void getInfo()
  {

    FirebaseFirestore.instance
        .collection(INFO_COLLECTION)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if(element.id == 'appleId') {
          appleId = element['val'];
        }
        if(element.id == 'hotline') {
          hotline = element['val'];
        }
        if(element.id == 'whatsapp') {
          whatsapp = element['val'];
        }
        if(element.id == 'complaints') {
          complaints = element['val'];
        }
        if(element.id == 'open') {
          open = element['val'];
        }
        if(element.id == 'invite_btn') {
          inviteBtn = element['val'];
        }
        if(element.id == 'about') {
          about = element['val'];
        }
        if(element.id == 'about_ar') {
          aboutAr = element['val'];
        }
        if(element.id == 'appVersion'){
          androidVersion = element['androidVersion'];
          iosVersion = element['iosVersion'];
        }
      });
      emit(GetStoreInfoStateSuccess(open,androidVersion,iosVersion,appleId));
    }).catchError((onError){
      print('ErrorInfo: ${onError.toString()}');
    });
  }


  void callNumber() async {
    String url = "tel://" + hotline;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if(Platform.isIOS) {
        launch('tel:$hotline');
      } else {
        throw 'Could not call $hotline';
      }

    }
  }

  void whatsappLaunch() async {
    String url = "https://wa.me/$whatsapp?text=Hello From Red App";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch whatsapp $whatsapp';
    }
  }

  //Contact Screen
  void submitUserMessage({required String uid,required String name, required String phone,required String message}) {
    emit(UserSubmitContactMessageLoadingState());
    MessagesModel model = MessagesModel(uid, name, phone, message, DateTime.now().millisecondsSinceEpoch);
    FirebaseFirestore.instance
        .collection(MESSAGES_COLLECTION)
        .doc(uid)
        .set(model.toMap()).then((value) {
          emit(UserSubmitContactMessageSuccessState());
    }).catchError((onError){
      print('ErrorInfo: ${onError.toString()}');
      emit(UserSubmitContactMessageErrorState(onError.toString()));
    });
  }


}

