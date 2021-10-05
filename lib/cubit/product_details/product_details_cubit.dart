
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';
import 'package:flutterecom/data/models/product_addon_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

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

  int groupValue = 0;

  void emitSizeChange(int newValue) {
    groupValue = newValue;
    print('NewVal ${groupValue}');
    emit(emitRadioChangeState());
  }

  //bool currentAddonSelected = false;
  //ProductAddonModel currentAddonSelected = ProductAddonModel(false);

  List<ProductAddonModel> userSelectedAddons = [];

  bool isSelectedService(ProductAddonModel e) {
    return userSelectedAddons.contains(e);
  }

  void emitAddonChange(bool isSelected,ProductAddonModel e) {
    if(isSelected){
      userSelectedAddons.add(e);
    }
    else{
      userSelectedAddons.remove(e);
    }

    emit(emitFilterChangeState());
  }

  Future<File> downloadProImageToShare(String proImage,String name) async {

    emit(DownloadProImageToShareLoadingState());

    final response = await http.get(Uri.parse(proImage));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(documentDirectory.path+'image.png');

    file.writeAsBytesSync(response.bodyBytes);

    emit(DownloadProImageToShareSuccessState());

    return file;

  }








}