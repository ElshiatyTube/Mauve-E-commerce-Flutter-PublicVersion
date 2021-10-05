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



}

