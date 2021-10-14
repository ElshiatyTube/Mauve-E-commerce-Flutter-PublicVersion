import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/cart/cart_cubit.dart';
import 'package:flutterecom/cubit/cart/cart_state.dart';
import 'package:flutterecom/shared/network/local/hive/employee.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';


class CartItem extends StatelessWidget {
  final Employee cartItem;
  const CartItem({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white
            ),
            child: CachedNetworkImage(
                fit: BoxFit.contain,
                height: 85.0,width: 85.0,
                imageUrl: cartItem.productImage,
            ),
          ),
          const SizedBox(width: 10.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cartItem.productName ,style: const TextStyle(fontSize: 12.0),),
                const SizedBox(height: 5.0,),
                cartItem.productAddon!='none' ? Text(cartItem.productAddon ,style: Theme.of(context).textTheme.caption) : Container(),
                const SizedBox(height: 2.0,),
                cartItem.productSize!='none' ? Text(cartItem.productSize ,style: Theme.of(context).textTheme.caption) : Container(),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                            height: 30,width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0),
                                color: MyColors.scaffoldBackgroundColorMain
                            ),
                            child: const Center(child:Icon(
                              Icons.remove,
                              color: Colors.black,
                              size: 15.0,
                            )),
                          ),
                          onTap: (){
                            if (cartItem.quantity != 1){
                              CartCubit.get(context).decreaseProductQuantity(productItem: cartItem);
                            }
                          },
                        ),
                        const SizedBox(width: 5.0,),
                        Text('${cartItem.quantity}'),
                        const SizedBox(width: 5.0,),
                        InkWell(
                          child: Container(
                            height: 30,width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: MyColors.scaffoldBackgroundColorMain
                            ),
                            child: const Center(child:Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 15.0,
                            )),
                          ),
                          onTap: (){
                            if (cartItem.quantity < 20){
                              CartCubit.get(context).increaseProductQuantity(productItem: cartItem);
                            }
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text('${cartItem.price} EGP',style: const TextStyle(color: defaultColor,fontSize: 13.0),),
                    const SizedBox(width: 10.0,),
                    InkWell(
                      child: Container(
                        height: 30,width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: MyColors.scaffoldBackgroundColorMain
                        ),
                        child: const Center(child:Icon(
                          Iconly_Broken.Delete,
                          color: MyColors.iconsColor,
                          size: 17.0,
                        )),
                      ),
                      onTap: (){
                        CartCubit.get(context).deleteProductFromCart(productModel: cartItem);
                      },
                    ),
                  ],
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
