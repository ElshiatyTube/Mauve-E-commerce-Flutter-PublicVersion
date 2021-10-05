import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/style/colors.dart';

import 'add_to_cart_btn.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel productItem;
  const ProductGridItem({Key? key, required this.productItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, productDetailsPath ,arguments: productItem);
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 4.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CachedNetworkImage(
                  width: double.infinity,
                  height: 85.0,
                  imageUrl: productItem.image,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                if (productItem.oldPrice > productItem.price)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Text(
                      'DISCOUNT'.tr(),
                      style: const TextStyle(fontSize: 9.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  AutoSizeText(
                    context.locale.toString() == 'en_EN'?  productItem.name: productItem.name_ar,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.0,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height:10.0 ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        '${productItem.price} ' + 'EGP'.tr(),
                        style: const TextStyle(
                          fontSize: 13.0,
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
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  productItem.size == null ? Column(
                    children: const[
                       SizedBox(height:10.0 ),
                       Align(child: AddToCartBTN(),alignment: Alignment.center,),
                    ],
                  ) : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
