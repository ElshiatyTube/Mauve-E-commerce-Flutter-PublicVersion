import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';
import 'package:flutterecom/data/api/reviews_api.dart';
import 'package:flutterecom/data/models/product_addon_model.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/data/models/product_rate_model.dart';
import 'package:flutterecom/data/models/product_size_model.dart';
import 'package:flutterecom/data/repo/reviews_repo.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  ProductDetailsCubit() : super(HomeLayoutInitState());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);

  int productQuantityCounter = 1;

  void increaseProductQuantityCounter() {
    productQuantityCounter++;
    emit(IncreaseProductQuantityCounterState());
  }

  void decreaseProductQuantityCounter() {
    productQuantityCounter--;
    emit(DecreaseProductQuantityCounterState());
  }

  int groupValue = 0;

  ProductSizeModel userSelectedSize = ProductSizeModel(name_ar: '',name: '',price: 0);

  void emitSizeChange(int newValue,ProductSizeModel selectedSize) {
    groupValue = newValue;
    userSelectedSize = selectedSize;
    emit(emitRadioChangeState());
  }

  List<ProductAddonModel> userSelectedAddons = [];


  bool isSelectedService(ProductAddonModel e) {
    return userSelectedAddons.contains(e);
  }

  void emitAddonChange(bool isSelected, ProductAddonModel e) {
    if (isSelected) {
      userSelectedAddons.add(e);
    } else {
      userSelectedAddons.remove(e);
    }

    emit(emitFilterChangeState());
  }

  Future<File> downloadProImageToShare(String proImage, String name) async {
    emit(DownloadProImageToShareLoadingState());

    final response = await http.get(Uri.parse(proImage));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(documentDirectory.path + 'image.png');

    file.writeAsBytesSync(response.bodyBytes);

    emit(DownloadProImageToShareSuccessState());

    return file;
  }

  double ratingVal = 5;

  void changeRatingValue({required double newValue}) {
    ratingVal = newValue;
    emit(emitChangeRatingValueState());
  }



  void submitUserProductRate(
      {required String comment,
      required String itemName,
      required String itemId,
      required String commentTime,
      required num ratingValue,
      required String catMenuId,
      required String userName,
      required String userId,
        required double currentItemRatingValue,
        required int currentItemRatingCount,
      }) {
    emit(SubmitUserProductRateLoadingState());

    print('UserName: ${userName}, UserId: ${userId}, CatId: ${catMenuId}');

    ProductRateModel productRateModel = ProductRateModel(
        name: userName,
        uid: userId,
        comment: comment,
        itemName: itemName,
        itemId: itemId,
        commentTime: commentTime,
        ratingValue: ratingValue);

    FirebaseFirestore.instance
        .collection(CATEGORIES_COLLECTION)
        .doc(catMenuId)
        .collection(PRODUCTS_COLLECTION)
        .doc(itemId)
        .collection(RATES_COLLECTION)
        /* .doc(userId)
        .set(productRateModel.toMap())*/
        .add(productRateModel.toMap())
        .then((value) {

      Map<String, dynamic> updateRateMap = {};
      updateRateMap['ratingCount'] = currentItemRatingCount + 1;
      updateRateMap['ratingValue'] = currentItemRatingValue + ratingValue.toDouble();
      FirebaseFirestore.instance
          .collection(CATEGORIES_COLLECTION)
          .doc(catMenuId)
          .collection(PRODUCTS_COLLECTION)
          .doc(itemId)
      .update(updateRateMap)
      .then((value) {
        emit(SubmitUserProductRateSuccessState());
      });

    }).catchError((onError) {
      emit(SubmitUserProductRateErrorState(onError.toString()));
    });
  }

  late List<ProductRateModel> productRateLimitedList;
  late List<ProductRateModel> productRateList;

  void getProductItemRates(
      {required ProductModel productItem, required hasLimit}) async {
    emit(ProductsRatesLoadingState());

    if(hasLimit)
    {
      productRateLimitedList=[];
      ReviewsRepo reviewsRepo = ReviewsRepo(ReviewsApi(productItem: productItem,rateList: productRateLimitedList));
      reviewsRepo.getReviews().then((value) {
        productRateLimitedList = value;
        emit(ProductsRatesSuccessState());
      }).catchError((onError){
        emit(ProductsRatesErrorState(onError.toString()));
      });
    }
    else{
      productRateList=[];
      ReviewsRepo reviewsRepo = ReviewsRepo(ReviewsApi(productItem: productItem,rateList: productRateList));
      reviewsRepo.getReviewsNonLimited().then((value) {
        productRateList = value;
        emit(ProductsRatesSuccessState());
      }).catchError((onError){
        emit(ProductsRatesErrorState(onError.toString()));
      });
    }


  }


 late List<ProductModel> suggestedProducts;

  void getProductSuggestedItems({required ProductModel productItem,required BuildContext context}){
    emit(SuggestedProLoadingState());

    suggestedProducts=[];

    if(HomeLayoutCubit.get(context).productList.length > 1){
      HomeLayoutCubit.get(context).productList.forEach((element) {
        int currentIndex = HomeLayoutCubit.get(context).productList.indexOf(element);
        if(currentIndex < 10){
          if(element.id !=productItem.id){
            suggestedProducts.add(element);
          }
        }
      });
      emit(SuggestedProSuccessState());
    }else{
      emit(SuggestedProIsEmptyState());
    }

  }

}

