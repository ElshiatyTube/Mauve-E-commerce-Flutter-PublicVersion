import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/shared/constants/constants.dart';

class ProductsApi {
  List<ProductModel> productList;
  CategoriesModel selectedCategoryItem;

  ProductsApi({required this.productList,required this.selectedCategoryItem});

  Future<dynamic> getProducts() async => FirebaseFirestore.instance
      .collection(CATEGORIES_COLLECTION)
      .doc(selectedCategoryItem.menu_id)
      .collection(PRODUCTS_COLLECTION)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      var productModel = ProductModel.fromJson(element.data());
      productModel.id = element.id;
      productModel.reference = element.reference;
      productList.add(productModel);
    });
    return productList;
  }).catchError((onError) {
    throw (onError.toString()); // error thrown
  });
}