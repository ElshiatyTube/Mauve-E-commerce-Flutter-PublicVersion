import 'package:flutterecom/data/models/category_model.dart';

abstract class HomeLayoutStates{}

class HomeLayoutInitState extends HomeLayoutStates {}

class UpdateMainUserTokenStateSuccess extends HomeLayoutInitState{}

class UpdateMainUserTokenStateFailed extends HomeLayoutInitState{}

class UpdateMainUserTokenStateNotLogin extends HomeLayoutInitState{}


//notification
class GetNotifyDataBackgroundSuccess extends HomeLayoutInitState{
  final String backgroundData;
  GetNotifyDataBackgroundSuccess(this.backgroundData);
}
class InitFirebaseBackgroundFCMSucess extends HomeLayoutInitState{}

//Get User Data States
class GetUserDataSuccessState extends HomeLayoutInitState{}
class GetUserDataFailedState extends HomeLayoutInitState{
  final String error;

  GetUserDataFailedState(this.error);
}



//Home States
class SliderIndicatorChange extends HomeLayoutInitState{}

//Category States
class LoadingCategoriesState extends HomeLayoutInitState{}
class SuccessCategoriesState extends HomeLayoutInitState{

}
class FailedCategoriesState extends HomeLayoutInitState{
  final String error;

  FailedCategoriesState(this.error);
}

class ChangeBottomNavState extends HomeLayoutInitState{}
class NavigateToProductListByCategoryState extends HomeLayoutInitState{
  final CategoriesModel categoryItem;

  NavigateToProductListByCategoryState(this.categoryItem);
}









