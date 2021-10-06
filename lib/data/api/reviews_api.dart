import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/data/models/product_rate_model.dart';
import 'package:flutterecom/shared/constants/constants.dart';

class ReviewsApi {
  List<ProductRateModel> rateList;
  ProductModel productItem;

  ReviewsApi({required this.rateList,required this.productItem});

  Future<dynamic> getReviewNonLimited() async => FirebaseFirestore.instance
      .collection(CATEGORIES_COLLECTION)
      .doc(productItem.menu_id)
      .collection(PRODUCTS_COLLECTION)
      .doc(productItem.id)
      .collection(RATES_COLLECTION).orderBy('commentTime',descending: true).get().then((value) {
    value.docs.forEach((element) {
      rateList.add(ProductRateModel.fromJson(element.data()));
    });
    return rateList;
  }).catchError((onError) {
    throw (onError.toString()); // error
  });


  Future<dynamic> getReviews() async => FirebaseFirestore.instance
      .collection(CATEGORIES_COLLECTION)
      .doc(productItem.menu_id)
      .collection(PRODUCTS_COLLECTION)
      .doc(productItem.id)
      .collection(RATES_COLLECTION).limit(3).get().then((value) {
    value.docs.forEach((element) {
      rateList.add(ProductRateModel.fromJson(element.data()));
    });
    return rateList;
  }).catchError((onError) {
    throw (onError.toString()); // error
  });



}
