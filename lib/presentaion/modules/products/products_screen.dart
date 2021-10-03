import 'package:flutter/cupertino.dart';
import 'package:flutterecom/data/models/category_model.dart';

class ProductsScreen extends StatelessWidget {
  final CategoriesModel categoriesItem;
  const ProductsScreen({Key? key, required this.categoriesItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(categoriesItem.name),
        ],
      ),
    );
  }
}
