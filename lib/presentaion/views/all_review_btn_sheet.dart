import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/product_details/product_details_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/presentaion/views/review_item.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class AllReviewBtnSheet extends StatefulWidget {
  final ProductModel productItem;
  const AllReviewBtnSheet({Key? key, required this.productItem}) : super(key: key);

  @override
  State<AllReviewBtnSheet> createState() => _AllReviewBtnSheetState();
}

class _AllReviewBtnSheetState extends State<AllReviewBtnSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductDetailsCubit.get(context).getProductItemRates(productItem: widget.productItem,hasLimit: false);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0x00737373), borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height / 2,
      child: Container(
        decoration: const BoxDecoration(
            color: MyColors.scaffoldBackgroundColorMain,
            borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 10.0,),
            Container(
              width: 60.0 ,
              height: 2.5,
              color: Colors.grey,
            ),
            const SizedBox(height: 10.0,),
            BlocBuilder<ProductDetailsCubit,ProductDetailsStates>(
              builder: (context,state){
                return ConditionalBuilder(
                  condition: ProductDetailsCubit.get(context).productRateList.isNotEmpty,
                  builder: (BuildContext context) {
                    return Expanded(
                      child:
                      LazyLoadScrollView(
                        isLoading: state is ProductsRatesLoadingState,
                        onEndOfPage:()=> loadMore() , ///for late pagination imp
                        child: Scrollbar(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              ListView.separated(
                                separatorBuilder: (context,index) => const SizedBox(height: 5.0,),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ProductDetailsCubit.get(context).productRateList.length,
                                itemBuilder: (context,index){
                                  return ReviewItem(productRateItem: ProductDetailsCubit.get(context).productRateList[index],);
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    );
                  },
                  fallback: (BuildContext context)=>defaultLinearProgressIndicator(),

                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future loadMore() async { ///for late pagination imp
    await Future.delayed(const Duration(seconds: 2));
    print('loadMor');
  }
}
