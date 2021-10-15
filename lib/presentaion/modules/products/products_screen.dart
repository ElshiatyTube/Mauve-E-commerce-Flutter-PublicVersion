import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_state.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/presentaion/views/products_grid_item.dart';
import 'package:flutterecom/presentaion/views/tab_view_page_item.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';

class ProductsScreen extends StatefulWidget {
  final CategoriesModel categoriesItem;

  const ProductsScreen({Key? key, required this.categoriesItem})
      : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeLayoutCubit.get(context)
        .getProductsByCategoryMenuId(categoriesItem: widget.categoriesItem);
  }

  @override
  Widget build(BuildContext context) {
    print('This is Product Screen');
    var cubit = HomeLayoutCubit.get(context);

    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
      listener: (context, state) {
        if (state is FailedProductsState) {
          print('FailedGetProductsState: ${state.error.toString()}');
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: cubit.productList.isNotEmpty,
          builder: (context) {
            return DefaultTabController(
              length: widget.categoriesItem.subCat != null
                  ? widget.categoriesItem.subCat!.length
                  : 1,
              initialIndex: 0,
              child: Column(
                children: [
                  widget.categoriesItem.subCat != null
                      ? TabBar(
                          isScrollable: true,
                          unselectedLabelColor: MyColors.iconsColor,
                          indicatorColor: defaultColor,
                          labelColor: defaultColor,
                          tabs: widget.categoriesItem.subCat!
                              .map(
                                (e) => Tab(
                                  child: Text(
                                    e.toString(),
                                  ),
                                ), //
                              )
                              .toList(),
                        )
                      : Container(),
                  widget.categoriesItem.subCat != null
                      ? Expanded(
                          child: TabBarView(
                            physics: const BouncingScrollPhysics(),
                            children: widget.categoriesItem.subCat!.map((e) {
                              return TabViewPageItem(
                                productList: cubit.productList
                                    .where((element) =>
                                        element.subCat == e.toString())
                                    .toList(),
                              );
                            }).toList(),
                          ),
                        )
                      : Expanded(
                          child: TabViewPageItem(
                            productList: cubit.productList,
                          ),
                        )
                ],
              ),
            );
          },
          fallback: (BuildContext context) => defaultLinearProgressIndicator(),
        );
      },
    );
  }

}
