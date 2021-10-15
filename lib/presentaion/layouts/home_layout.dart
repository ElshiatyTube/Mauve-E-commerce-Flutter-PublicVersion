import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/cart/cart_cubit.dart';
import 'package:flutterecom/cubit/cart/cart_state.dart';
import 'package:flutterecom/cubit/check_connection/check_connection_cubit.dart';
import 'package:flutterecom/cubit/check_connection/check_connection_state.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_state.dart';
import 'package:flutterecom/data/models/category_model.dart';
import 'package:flutterecom/presentaion/modules/categories/categories_screen.dart';
import 'package:flutterecom/presentaion/modules/home/home_screen.dart';
import 'package:flutterecom/presentaion/modules/products/products_screen.dart';
import 'package:flutterecom/presentaion/views/cart_badge_btn.dart';
import 'package:flutterecom/presentaion/views/categoryies_grid_item.dart';
import 'package:flutterecom/presentaion/views/default_form_field.dart';
import 'package:flutterecom/presentaion/views/slider_item.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:one_context/one_context.dart';
import 'package:shimmer/shimmer.dart';

class HomeLayout extends StatelessWidget {
   HomeLayout({Key? key}) : super(key: key);

   final searchController = TextEditingController();
   Widget _widgetInBody = HomeScreen();
   DateTime? currentBackPressTime;


   @override
  Widget build(BuildContext context) {
    var cubit = HomeLayoutCubit.get(context);

    print('LayoutRebuild');

    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(

      listener: (BuildContext context, Object? state) {
        if (state is UpdateMainUserTokenStateSuccess) {
          showToast(msg: 'TokenUpdated', state: ToastedStates.SUCCESS);
        }
        if (state is UpdateMainUserTokenStateFailed) {
          showToast(msg: 'TokenNotUpdated', state: ToastedStates.ERROR);
        }
        if (state is ChangeBottomNavState) {
          _widgetInBody = cubit.bottomScreens[cubit.currentIndex];
          print('Btn_va_Current_index: ${cubit.currentIndex}');
        }
        if (state is NavigateToToCategoryListState) {
          if(cubit.currentIndex!=1){
            cubit.currentIndex = 1;
          }
          _widgetInBody = const CategoriesScreen();
        }
        if(state is NavigateToProductListByCategoryState){
          if(cubit.currentIndex!=1){
            cubit.currentIndex = 1;
          }
          _widgetInBody = ProductsScreen(categoriesItem: state.categoryItem);
        }

      },
      builder: (context,state){
        print('_widgetInBody ${_widgetInBody.toString()}');
        return Scaffold(
            appBar: AppBar(
              leading: _widgetInBody.toString() == 'ProductsScreen' ? IconButton(
                icon: Icon(
                  context.locale.toString() == 'en_EN'
                      ? Iconly_Broken.Arrow___Left_2
                      : Iconly_Broken.Arrow___Right_2,
                ),
                onPressed: () {
                  cubit.changeBottom(1);
                },
              ) : Image.asset('assets/images/appbarlogo.png',),
              title: DefaultFormField(
                bgColor: MyColors.wightBG,
                isDense: true,
                validator: (String? value) {},
                prefixIcon: Iconly_Broken.Search,
                suffixIcon: Iconly_Broken.Filter,
                controller: searchController,
                label: 'Search'.tr(),
                textInputType: TextInputType.emailAddress,
              ),
              actions: const[
                 CartBadgeBtn(),
              ],
            ),
            body: WillPopScope(onWillPop: onWillPop,
            child: _widgetInBody),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              // showSelectedLabels: false,
              unselectedFontSize: 0.0,
              selectedIconTheme: const IconThemeData(color: defaultColor),
              backgroundColor: Colors.white,
              currentIndex: cubit.currentIndex,
              onTap: (int index){
                cubit.changeBottom(index);
              },
              items: const[
                BottomNavigationBarItem(
                  icon: Icon(Iconly_Broken.Home,color: MyColors.iconsColor,),
                  label: 'Home',
                  activeIcon: Icon(
                    Iconly_Broken.Home,
                    color: defaultColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconly_Broken.Category,color: MyColors.iconsColor,),
                  label: 'Categories',
                  activeIcon: Icon(
                    Iconly_Broken.Category,
                    color: defaultColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconly_Broken.Bag_2,color: MyColors.iconsColor,),
                  label: 'Orders',
                  activeIcon: Icon(
                    Iconly_Broken.Bag_2,
                    color: defaultColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconly_Broken.User,color: MyColors.iconsColor,),
                  label: 'Account',
                  activeIcon: Icon(
                    Iconly_Broken.User,
                    color: defaultColor,
                  ),
                ),
              ],

            )
        );
      },

    );
  }
   Future<bool> onWillPop() {
     DateTime now = DateTime.now();
     if (currentBackPressTime == null ||
         now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
       currentBackPressTime = now;
       showToast(msg: 'Press again to exit', state: ToastedStates.WARNING);
       return Future.value(false);
     }
     return Future.value(true);
   }
}

