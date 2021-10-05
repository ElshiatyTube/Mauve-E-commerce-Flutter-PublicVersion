import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates>{
  ProductDetailsCubit() : super(HomeLayoutInitState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);


  int productQuantityCounter = 1;
  void increaseProductQuantityCounter(){
    productQuantityCounter ++;
    emit(IncreaseProductQuantityCounterState());
  }
  void decreaseProductQuantityCounter(){
    productQuantityCounter --;
    emit(DecreaseProductQuantityCounterState());
  }

}