import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';

import 'default_btn.dart';

class SubmitReviewSheet extends StatelessWidget {
   final rateTextController = TextEditingController();
   final ProductModel productItem;

   SubmitReviewSheet({Key? key,required rateTextController, required this.productItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
      builder: (context,state){
        return Container(
          padding: const EdgeInsets.all(8.0),
          height: 200.0,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: ProductDetailsCubit.get(context).ratingVal,
                minRating: 1,
                direction: Axis.horizontal,
                itemSize: 35.0,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  ProductDetailsCubit.get(context).changeRatingValue(newValue: rating);
                },
              ),
              const SizedBox(height: 10.0,),
              Expanded(
                child: TextFormField(
                  controller: rateTextController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Write your review (optional)...',
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Iconly_Broken.Edit_Square,
                    ),
                  ),
                ),
              ),
              ConditionalBuilder(
                condition: state is! SubmitUserProductRateLoadingState,
                builder: (context){
                  return DefaultButtonView(function: (){
                    var now = DateTime.now();
                    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                    ProductDetailsCubit.get(context).submitUserProductRate(
                      currentItemRatingValue: productItem.ratingValue.toDouble(),
                      currentItemRatingCount: productItem.ratingCount.toInt(),
                      comment: rateTextController.text.isNotEmpty ? rateTextController.text : '' ,
                      itemName: productItem.name,
                      itemId: productItem.id!,
                      ratingValue: ProductDetailsCubit.get(context).ratingVal,
                      commentTime: formattedDate,
                      catMenuId: HomeLayoutCubit.get(context).selectedCategory.menu_id!,
                      userName: AuthCubit.get(context).userModel.name,
                      userId: AuthCubit.get(context).userModel.uId,
                    );
                  }, text: 'Send',radius: 8.0,background: defaultColor,);
                },
                fallback: (context)=>defaultLinearProgressIndicator(),
              ),
            ],
          ),
        );
      },

    );
  }
}
