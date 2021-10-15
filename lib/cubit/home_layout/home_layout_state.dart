import 'package:flutterecom/data/models/category_model.dart';

abstract class HomeLayoutStates{}

class HomeLayoutInitState extends HomeLayoutStates {}

class UpdateMainUserTokenStateSuccess extends HomeLayoutStates{}

class UpdateMainUserTokenStateFailed extends HomeLayoutStates{}

class UpdateMainUserTokenStateNotLogin extends HomeLayoutStates{}


//notification
class GetNotifyDataBackgroundSuccess extends HomeLayoutStates{
  final String backgroundData;
  GetNotifyDataBackgroundSuccess(this.backgroundData);
}
class InitFirebaseBackgroundFCMSucess extends HomeLayoutStates{}

//Get User Data States
class GetUserDataSuccessState extends HomeLayoutStates{}
class GetUserDataFailedState extends HomeLayoutStates{
  final String error;

  GetUserDataFailedState(this.error);
}



//Home States
class SliderIndicatorChange extends HomeLayoutStates{}

//Category States
class LoadingCategoriesState extends HomeLayoutStates{}
class SuccessCategoriesState extends HomeLayoutStates{

}
class FailedCategoriesState extends HomeLayoutStates{
  final String error;

  FailedCategoriesState(this.error);
}
//Products States
class LoadingProductsState extends HomeLayoutStates{}
class SuccessProductsState extends HomeLayoutStates{

}
class FailedProductsState extends HomeLayoutStates{
  final String error;

  FailedProductsState(this.error);
}

//Navigation States
class ChangeBottomNavState extends HomeLayoutStates{}
class NavigateToProductListByCategoryState extends HomeLayoutStates{
  final CategoriesModel categoryItem;

  NavigateToProductListByCategoryState(this.categoryItem);
}
class NavigateToToCategoryListState extends HomeLayoutStates{}


//Setting Screen
class WelcomeState extends HomeLayoutStates{}

class GetStoreInfoStateSuccess extends HomeLayoutStates{
  final bool openState;
  final int androidVersion,iosVersion;
  final String appleId;

  GetStoreInfoStateSuccess(
      this.openState, this.androidVersion, this.iosVersion,this.appleId);
}


//Contact Screen
class UserSubmitContactMessageLoadingState extends HomeLayoutStates{}
class UserSubmitContactMessageSuccessState extends HomeLayoutStates{}
class UserSubmitContactMessageErrorState extends HomeLayoutStates{
  final String error;

  UserSubmitContactMessageErrorState(this.error);
}













