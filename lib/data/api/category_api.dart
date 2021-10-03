import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/shared/constants/constants.dart';

class CategoryApi {
  List<CategoriesModel> categoryList;

  CategoryApi(this.categoryList);

  Future<dynamic> getCategories() async => FirebaseFirestore.instance
          .collection(CATEGORIES_COLLECTION)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          var categoryModel = CategoriesModel.fromJson(element.data());
          categoryModel.menu_id = element.id;
          categoryList.add(categoryModel);
        });
        return categoryList;
      }).catchError((onError) {
        throw (onError.toString()); // error thrown
      });
}
