import 'package:flutterecom/data/api/products_api.dart';
import 'package:flutterecom/data/models/product_model.dart';

class ProductsRepo{
  final ProductsApi productsApi;

  ProductsRepo(this.productsApi);

  Future<List<ProductModel>> getProducts() async{
    final products = await productsApi.getProducts();
    return products.toList();
  }
}