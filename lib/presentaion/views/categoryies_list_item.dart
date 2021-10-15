import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryListItem extends StatelessWidget {

  final CategoriesModel categoryItem;
  const CategoryListItem({Key? key, required this.categoryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        HomeLayoutCubit.get(context).navigateToProductListByCategory(categoryItem: categoryItem);
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(
                width: 65.0,
                height: 65.0,
                fit: BoxFit.contain,
                imageUrl: categoryItem.image,
                placeholder: (context, url) => Container(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),

            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                context.locale.toString() == 'en_EN'?  categoryItem.name : categoryItem.name_ar,
              ),
            ),
            //  Spacer(),
            Icon(
              context.locale.toString() == 'en_EN' ? Iconly_Broken.Arrow___Right_2 : Iconly_Broken.Arrow___Left_2,
              color: defaultColor,
            ),
          ],
        ),
      ),
    );
  }
}
