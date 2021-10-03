import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:shimmer/shimmer.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoriesModel categoriesItem;

  const CategoryGridItem({Key? key, required this.categoriesItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        HomeLayoutCubit.get(context).navigateToProductListByCategory(categoryItem: categoriesItem);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        width: 100.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: categoriesItem.image,
              fit: BoxFit.cover,
              height: 50.0,
              width: 50.0,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ), //Image
            const SizedBox(
              height: 5.0,
            ), // e
            AutoSizeText(
              categoriesItem.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              '+89',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.normal,
                  fontSize: 13.0),
            ),
          ],
        ),
      ),
    );
  }
}
