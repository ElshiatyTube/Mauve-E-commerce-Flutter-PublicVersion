import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_state.dart';
import 'package:flutterecom/presentaion/layouts/home_layout.dart';
import 'package:flutterecom/presentaion/views/add_to_cart_btn.dart';
import 'package:flutterecom/presentaion/views/categoryies_grid_item.dart';
import 'package:flutterecom/presentaion/views/slider_item.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';

class HomeScreen extends StatefulWidget {

   HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<OfferMode> offers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Static UI, You Can make it dynamic with the same fetch data approach I use in this project.
    offers.add(OfferMode(
        '123',
        'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/newDesign%2Fslide1.jpg?alt=media&token=88dffeed-5ec9-4807-a7c2-6c7c68c2fa8f',
        'ALL YOU NEED1'));
    offers.add(OfferMode(
        '123',
        'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/newDesign%2Fslide2.jpg?alt=media&token=705ed643-e95a-44f0-bf3d-3fa3823dff07',
        'ALL YOU NEED2'));
    offers.add(OfferMode(
        '123',
        'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/newDesign%2Fslide3.jpg?alt=media&token=39a18686-2ed0-43ca-83f2-e889bdfff3b8',
        'All YOU NEED3'));
  }
  @override
  Widget build(BuildContext context) {
   var cubit = HomeLayoutCubit.get(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Categories',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0)),
                const Spacer(),
                InkWell(
                  onTap: (){
                    cubit.navigateToCategoryList();
                  },
                  child: const Text(
                    'SeeAll',
                    style: TextStyle(
                        color: defaultColor,
                        decoration: TextDecoration.underline,
                        fontSize: 13.0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
              listener: (context, state) {
                if (state is FailedCategoriesState) {
                  print(
                      'FailedCategoriesStateError: ${state.error.toString()}');
                  showToast(msg: state.error, state: ToastedStates.WARNING);
                }
              },
              builder: (context, state) {
                return ConditionalBuilder(
                  condition: cubit.categoryList.isNotEmpty,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 120.0,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryGridItem(
                            categoriesItem: cubit.categoryList[index],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 10.0,
                        ),
                        itemCount:
                        HomeLayoutCubit.get(context).categoryList.length,
                      ),
                    );
                  },
                  fallback: (BuildContext context) =>
                      defaultLinearProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            BlocBuilder<HomeLayoutCubit, HomeLayoutStates>(
              builder: (BuildContext context, state) {
                return CarouselSlider(
                  options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      initialPage: 0,
                      viewportFraction: 1.0,
                      scrollDirection: Axis.horizontal,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        cubit.homeSliderIndicator(index);
                      }),
                  items: offers.map((offerItem) {
                    return SliderItem(
                      offerItem: offerItem,
                      offers: offers,
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:  [
                const Text('Offers',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0)),
                const Spacer(),
                InkWell(
                  onTap: (){
                   // cubit.navigateToCategoryList();
                  },
                  child: const Text(
                    'SeeAll',
                    style: TextStyle(
                        color: defaultColor,
                        decoration: TextDecoration.underline,
                        fontSize: 13.0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            //Static UI, You Can make it dynamic with the same fetch data approach I use in this project
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/newDesign%2F61tqeocT3ML._AC_SX679_.jpg?alt=media&token=d9265aeb-54b1-436a-bbc7-305fec602be6',
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Expanded(
                              child: Text(
                                'ALFA Furnishing Ergonomic Desk Chair ALFA Furnishing Ergonomic Desk Chair',
                                maxLines: 3,
                                style: TextStyle(fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const[
                              Text("96.00 EGP",style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),),
                              SizedBox(width: 5.0,),
                              Text("80.00 EGP",style: TextStyle(color: defaultColor),),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: defaultColor,
                                width: 1.5,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                            ),
                            child: const Padding(
                              padding:  EdgeInsets.only(right: 35.0,left: 35.0,top: 7.0,bottom: 7.0),
                              child:  Text('Add To Cart',style: TextStyle(color: defaultColor),),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                        4.0
                    ),
                    child: Text(
                      'DISCOUNT'.tr(),
                      style: const TextStyle(fontSize: 9.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/newDesign%2F6154tUlFvPL._AC_SL1500_.jpg?alt=media&token=6c7ae296-111d-49dd-8736-f57d312ac786',
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Expanded(
                              child: Text(
                                'ALFA Furnishing Ergonomic Desk Chair ALFA Furnishing Ergonomic Desk Chair',
                                maxLines: 3,
                                style: TextStyle(fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const[
                              Text("96.00 EGP",style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),),
                              SizedBox(width: 5.0,),
                              Text("80.00 EGP",style: TextStyle(color: defaultColor),),
                            ],
                          ),
                          const AddToCartBTN(),
                        ],
                      ),

                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                        4.0
                    ),
                    child: Text(
                      'DISCOUNT'.tr(),
                      style: const TextStyle(fontSize: 9.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/newDesign%2F61ia%2BclFWeL._AC_SL1500_.jpg?alt=media&token=708295e3-8284-4306-a8b6-103f43d2e912',
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Expanded(
                              child: Text(
                                'ALFA Furnishing Ergonomic Desk Chair ALFA Furnishing Ergonomic Desk Chair',
                                maxLines: 3,
                                style: TextStyle(fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const[
                              Text("96.00 EGP",style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),),
                              SizedBox(width: 5.0,),
                              Text("80.00 EGP",style: TextStyle(color: defaultColor),),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: defaultColor,
                                width: 1.5,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                            ),
                            child: const Padding(
                              padding:  EdgeInsets.only(right: 35.0,left: 35.0,top: 7.0,bottom: 7.0),
                              child:  Text('Add To Cart',style: TextStyle(color: defaultColor),),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                        4.0
                    ),
                    child: Text(
                      'DISCOUNT'.tr(),
                      style: const TextStyle(fontSize: 9.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: CachedNetworkImage(
                              imageUrl: 'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/newDesign%2F61ia%2BclFWeL._AC_SL1500_.jpg?alt=media&token=708295e3-8284-4306-a8b6-103f43d2e912',
                              height: 100.0,
                              width: 100.0,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Expanded(
                              child: Text(
                                'ALFA Furnishing Ergonomic Desk Chair ALFA Furnishing Ergonomic Desk Chair',
                                maxLines: 3,
                                style: TextStyle(fontSize: 12.0),
                                overflow: TextOverflow.ellipsis,
                              )
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const[
                              Text("96.00 EGP",style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),),
                              SizedBox(width: 5.0,),
                              Text("80.00 EGP",style: TextStyle(color: defaultColor),),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: defaultColor,
                                width: 1.5,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                            ),
                            child: const Padding(
                              padding:  EdgeInsets.only(right: 35.0,left: 35.0,top: 7.0,bottom: 7.0),
                              child:  Text('Add To Cart',style: TextStyle(color: defaultColor),),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(
                        4.0
                    ),
                    child: Text(
                      'DISCOUNT'.tr(),
                      style: const TextStyle(fontSize: 9.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class OfferMode {
  late String id;
  late String image;
  late String title;

  OfferMode(this.id, this.image, this.title);
}

