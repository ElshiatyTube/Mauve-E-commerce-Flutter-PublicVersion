import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/presentaion/views/categoryies_list_item.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit =HomeLayoutCubit.get(context);
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/istockphoto-907575112-170667a.jpg?alt=media&token=f4b86e6d-ebb7-461f-9785-c28b4c52dbdf',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: const Text(
                  'Choose your BRAND',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0,),
          ConditionalBuilder(
            condition:cubit.categoryList.isNotEmpty ,
            builder: (BuildContext context){
              return Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => animateListView(index: index,buildItemClass: CategoryListItem(categoryItem: cubit.categoryList[index])), ///CategoryListItem(categoryItem: cubit.categoryList[index],)
                  separatorBuilder: (context, index) => const SizedBox(height: 5.0,),
                  itemCount: cubit.categoryList.length,
                ),
              );
            },
            fallback: (BuildContext context) =>
                defaultLinearProgressIndicator(),
          ),
        ],
      ),
    );
  }

}
