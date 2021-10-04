import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/presentaion/views/products_grid_item.dart';

class TabViewPageItem extends StatelessWidget {
  final List<ProductModel> productList;
  const TabViewPageItem({Key? key, required this.productList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AnimationLimiter(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.25,
        children: List.generate(
          productList.length,
              (index) => AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: ProductGridItem(
                  productItem: productList[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
