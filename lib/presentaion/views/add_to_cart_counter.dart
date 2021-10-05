import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/product_details/product_details_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';
import 'package:flutterecom/shared/style/colors.dart';

class AddToCartCounter extends StatelessWidget {
  const AddToCartCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productDetailsCubit = ProductDetailsCubit.get(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: defaultColor),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                if (productDetailsCubit.productQuantityCounter != 1) {
                  productDetailsCubit.decreaseProductQuantityCounter();
                }
              },
              child: const Icon(
                Icons.remove,
                color: Colors.white,
                size: 23.0,
              )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: Colors.white),
            child: BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
              builder: (context, state) {
                return Text(
                  '${productDetailsCubit.productQuantityCounter}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                );
              },
            ),
          ),
          InkWell(
              onTap: () {
                if (productDetailsCubit.productQuantityCounter < 20) {
                  productDetailsCubit.increaseProductQuantityCounter();
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 23.0,
              )),
        ],
      ),
    );
  }
}
