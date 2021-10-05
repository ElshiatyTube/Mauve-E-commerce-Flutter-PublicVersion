import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_cubit.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutterecom/presentaion/views/add_to_cart_counter.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productItem;

  const ProductDetailsScreen({Key? key, required this.productItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: context.locale.toString() == 'en_EN'
              ? AutoSizeText(productItem.name)
              : AutoSizeText(productItem.name_ar),
          leading: IconButton(
            icon: Icon(
              context.locale.toString() == 'en_EN'
                  ? Iconly_Broken.Arrow___Left_2
                  : Iconly_Broken.Arrow___Right_2,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        productItem.image,
                        height: MediaQuery.of(context).size.height / 2,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        HomeLayoutCubit.get(context).selectedCategory.image,
                        height: 38.0,
                        width: 33.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15.0),
              context.locale.toString() == 'en_EN'
                  ? AutoSizeText(productItem.name)
                  : AutoSizeText(productItem.name_ar),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        '${productItem.price} ' + 'EGP'.tr(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (productItem.oldPrice > productItem.price)
                        AutoSizeText(
                          '${productItem.oldPrice} ' + 'EGP'.tr(),
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const AddToCartCounter(),
                ],
              ),
              const SizedBox(height: 15.0,),
              Text(
                'Description',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                    ),
                    child: Text(
                      context.locale.toString() == 'en_EN'? productItem.description: productItem.description_ar,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            productItem.size!=null ?  Column(
                children: [
                  Text(
                    'Size',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ) : Container(),

            ],
          ),
        ),
      ),
    );
  }
}