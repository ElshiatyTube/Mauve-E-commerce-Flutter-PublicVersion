import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';
import 'package:flutterecom/data/models/product_addon_model.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutterecom/data/models/product_rate_model.dart';
import 'package:flutterecom/presentaion/views/add_to_cart_counter.dart';
import 'package:flutterecom/presentaion/views/all_review_btn_sheet.dart';
import 'package:flutterecom/presentaion/views/radio_item_tile.dart';
import 'package:flutterecom/presentaion/views/review_grid_item.dart';
import 'package:flutterecom/presentaion/views/review_item.dart';
import 'package:flutterecom/presentaion/views/submit_review_sheet.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:share_extend/share_extend.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productItem;

  ProductDetailsScreen({Key? key, required this.productItem})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var rateTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.productItem.ratingValue!=0.1){
      ProductDetailsCubit.get(context).getProductItemRates(productItem: widget.productItem,hasLimit: true);
    }else{
      ProductDetailsCubit.get(context).productRateLimitedList=[];
    }
  }

  @override
  Widget build(BuildContext context) {
    print('This is ProductDetailsScreen');
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: context.locale.toString() == 'en_EN'
            ? AutoSizeText(widget.productItem.name)
            : AutoSizeText(widget.productItem.name_ar),
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
        actions: [
          Platform.isAndroid  ? BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
           builder: (context,state){
             return IconButton(
               onPressed: () {
                 ProductDetailsCubit.get(context).downloadProImageToShare(widget.productItem.image,widget.productItem.name)
                     .then((file) {
                   ShareExtend.share(file.path, "image",extraText: widget.productItem.name);
                 });
               },
               icon: const Icon(Iconly_Broken.Send,color: MyColors.iconsColor,),
             );
           },
          ) : Container(),
          IconButton(
            onPressed: () {
              scaffoldKey.currentState!.showBottomSheet((context) => SubmitReviewSheet(rateTextController:rateTextController,productItem: widget.productItem,));
            },
            icon: const Icon(Iconly_Broken.Ticket_Star,color: MyColors.iconsColor,),
          )
        ],
      ),
      body: BlocListener<ProductDetailsCubit,ProductDetailsStates>(
        listener: (context,state){
          if(state is SubmitUserProductRateErrorState){
            showToast(msg: state.error, state: ToastedStates.WARNING);
          }
          if(state is SubmitUserProductRateSuccessState){
            showToast(msg: 'Thank you, We will submit you review soon', state: ToastedStates.SUCCESS);
            Navigator.pop(context);
          }
          if(state is ProductsRatesErrorState){
            showToast(msg: state.error, state: ToastedStates.WARNING);
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
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
                        child: CachedNetworkImage(
                          imageUrl: widget.productItem.image,
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
                        child: CachedNetworkImage(
                          imageUrl: HomeLayoutCubit.get(context).selectedCategory.image,
                          height: 38.0,
                          width: 33.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    )
                  ],
                ),
                BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
                  builder: (context,state){
                    if(state is DownloadProImageToShareLoadingState) {
                      return defaultLinearProgressIndicator();
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 15.0),
                context.locale.toString() == 'en_EN'
                    ? AutoSizeText(widget.productItem.name)
                    : AutoSizeText(widget.productItem.name_ar),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          '${widget.productItem.price} ' + 'EGP'.tr(),
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: defaultColor,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (widget.productItem.oldPrice > widget.productItem.price)
                          AutoSizeText(
                            '${widget.productItem.oldPrice} ' + 'EGP'.tr(),
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
                widget.productItem.ratingValue!=0.1 ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Iconly_Broken.Star,color: Colors.amber,),
                    const SizedBox(width: 2.0,),
                    Text((widget.productItem.ratingValue / widget.productItem.ratingCount).toStringAsFixed(1),style: const TextStyle(color: MyColors.iconsColor),),
                    const SizedBox(width: 10.0,),
                    Text('${widget.productItem.ratingCount.toInt()} Reviews',style: const TextStyle(color: MyColors.iconsColor),),
                  ],
                ) : Container(),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 14.0,
                      ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 4.0,
                        right: 4.0,
                      ),
                      child: Text(
                        context.locale.toString() == 'en_EN'
                            ? widget.productItem.description
                            : widget.productItem.description_ar,
                        style: const TextStyle(
                          fontSize: 14.0,
                          height: 2.0,
                            color: MyColors.iconsColor,

                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
                    builder: (context,state){
                      print('ReBuildAddonSize');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.productItem.size != null
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Size',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
                                builder: (context,state){
                                  return Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    elevation: 0.8,
                                    child: Column(
                                      children: widget.productItem.size!
                                          .map((data) => RadioItemTile(
                                        onChanged: (newValue){
                                          ProductDetailsCubit.get(context).emitSizeChange(newValue);
                                        },
                                        title: context.locale.toString() == 'en_EN'?  '${data.name} ${data.price} EGP' : '${data.name_ar} ${data.price}ج.م ',
                                        value: widget.productItem.size!.indexOf(data),
                                      )).toList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                              : Container(),
                          widget.productItem.addon!=null
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Addons',
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
                                builder: (context,state){
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 0.8,
                                      child: Row(
                                        children:widget.productItem.addon!.map((e) => Wrap(
                                          children: [
                                            const SizedBox(width: 5.0,),
                                            FilterChip(
                                              label:context.locale.toString() == 'en_EN'?  Text('${e.name} +${e.price}LE',style: Theme.of(context).textTheme.caption,) : Text('${e.name_ar} +${e.price}LE',style: const TextStyle(color: MyColors.iconsColor),),
                                              selected:ProductDetailsCubit.get(context).isSelectedService(e),
                                              onSelected: (bool isSelected) {
                                                ProductDetailsCubit.get(context).emitAddonChange(isSelected, e);
                                              },
                                            ),
                                          ],
                                        )).toList() ,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                              :Container(),
                        ],
                      );
                    }
                ),
                const SizedBox(height: 8.0,),

                BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
                  builder: (BuildContext context, state) {
                    return ConditionalBuilder(
                      condition: ProductDetailsCubit.get(context).productRateLimitedList.isNotEmpty,
                      builder: (BuildContext context) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  child: Text('Reviews (${widget.productItem.ratingCount.toInt()})'
                                      ,style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14.0 ,color: defaultColor,decoration: TextDecoration.underline,)
                                  ),
                                  onTap: (){
                                    showBottomSheetForAllReviews(widget.productItem);
                                  },
                                ),
                                const Spacer(),
                                const Icon(Iconly_Broken.Star,color: Colors.amber,),
                                const SizedBox(width: 2.0,),
                                Text((widget.productItem.ratingValue / widget.productItem.ratingCount).toStringAsFixed(1),style: const TextStyle(color: MyColors.iconsColor),),
                              ],
                            ) ,
                            const SizedBox(height: 5.0,),
                            Container(
                              color: MyColors.scaffoldBackgroundColorMain,
                              height: 120.0,
                              child: ListView.separated(
                                separatorBuilder: (BuildContext context, int index) =>const SizedBox(width: 5.0,),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                //  shrinkWrap: true,
                                itemBuilder: (context,index){
                                  return ReviewGridItem(productRateItem: ProductDetailsCubit.get(context).productRateLimitedList[index]);
                                },
                                itemCount: ProductDetailsCubit.get(context).productRateLimitedList.length,

                              ),
                            ),
                          ],
                        );
                      },
                      fallback: (BuildContext context)=> state is ProductsRatesLoadingState ? defaultLinearProgressIndicator(): Container()  ,
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBottomSheetForAllReviews(ProductModel productItem) {
    showModalBottomSheet(
      elevation: 20.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return  AllReviewBtnSheet(productItem: productItem);
      },
    );
  }
}
