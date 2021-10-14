import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterecom/cubit/cart/cart_cubit.dart';
import 'package:flutterecom/cubit/cart/cart_state.dart';
import 'package:flutterecom/presentaion/views/cart_item.dart';
import 'package:flutterecom/presentaion/views/default_btn.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/hive/employee.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class CartScreen extends StatelessWidget{
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit,CartStates>(
      listener: (context,state){
        if(state is AddToCartErrorState){
        }
      },
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
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
              IconButton(
                  icon: const Icon(Iconly_Broken.Delete),
                  onPressed: () {
                    CartCubit.get(context).clearAllCartItems(context);
                  }),
            ],
          ),
          body: ValueListenableBuilder(
            valueListenable: Boxes.getEmployees().listenable(),
            builder: (context,Box box, _) {
              final cartItems = box.values.toList().cast<Employee>();
              if(cartItems.isEmpty){
                Future.delayed(const Duration(milliseconds: 50), () { //0.5 sec
                  Navigator.pop(context);
                });
              }

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          return CartItem(cartItem: cartItems[index]);
                        },
                        separatorBuilder: (context,index) => const SizedBox(height: 10.0,),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children:  [
                              const  Text('Total'),
                              const Spacer(),
                              cartItems.isNotEmpty ?  Text(cartItems.map((e) => e.price.toDouble() * e.quantity.toDouble()).reduce((value, element) => value + element).toStringAsFixed(2)+' EGP',style: const TextStyle(color: defaultColor),) : Container(),
                            ],
                          ),
                          const SizedBox(height: 20.0,),
                          DefaultButtonView(
                              function: (){},
                            background: defaultColor,
                              text: 'Checkout',
                          radius: 12.0,)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

}


