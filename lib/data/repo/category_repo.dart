import 'package:flutterecom/data/api/category_api.dart';
import 'package:flutterecom/data/models/category_model.dart';

class CategoryRepo{
  final CategoryApi categoryApi;

  CategoryRepo(this.categoryApi);

  Future<List<CategoriesModel>> getCategories() async{
    final categories = await categoryApi.getCategories();
    return categories.toList();
  }
}