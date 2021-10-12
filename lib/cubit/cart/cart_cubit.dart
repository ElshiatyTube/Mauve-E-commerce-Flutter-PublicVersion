import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/data/models/product_model.dart';
import 'package:flutterecom/presentaion/modules/cart/cart_screen.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/hive/employee.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartStates>{
  CartCubit() : super(CartInitState());

  static CartCubit get(context) => BlocProvider.of(context);


  void getProductInCartById({required String productId
    ,required String uid,
    required String productName,
    required String productImage,
    required String productAddon,
    required String productSize,
    required double price,
    required int quantity,
  }){
      final box = Boxes.getEmployees();
      Employee? item = box.get(productId);
      if(item!=null){
        if(item.productSize == productSize && item.productAddon == productAddon){ //Add with new addons,size
          item.quantity = item.quantity + quantity;
          item.save();
          showToast(msg: 'Quantity Updated', state: ToastedStates.SUCCESS);
        }else{
          print('updateAddonSize'); //updateAddonSize
          final cartItem = Employee()
            ..productId = productId
            ..uid = uid
            ..productName = productName
            ..productImage = productImage
            ..productAddon = productAddon
            ..productSize = productSize
            ..price = price
            ..quantity = quantity;

          final box = Boxes.getEmployees();
          box.put('${productId}_${UniqueKey().hashCode.toString()}', cartItem).then((value) {
            emit(AddToCartSuccessState());
            showToast(msg: 'Add Success', state: ToastedStates.SUCCESS);
          }).then((onError) {
            emit(AddToCartErrorState(onError.toString()));
          });
        }

      }
      else{
        print('itemIsNotExist'); //Add new
        final cartItem = Employee()
          ..productId = productId
          ..uid = uid
          ..productName = productName
          ..productImage = productImage
          ..productAddon = productAddon
          ..productSize = productSize
          ..price = price
          ..quantity = quantity;

        final box = Boxes.getEmployees();
        box.put(productId, cartItem).then((value) {
          emit(AddToCartSuccessState());
          showToast(msg: 'Add Success', state: ToastedStates.SUCCESS);
        }).then((onError) {
          emit(AddToCartErrorState(onError.toString()));
        });
      }
  }

  void deleteProductFromCart({required Employee productModel}){
    productModel.delete();
    emit(DeleteProductFromCartState());
  }

  void clearAllCartItems(BuildContext context){
    Boxes.getEmployees().clear().then((value) {
      emit(ClearAllCartItemsState());
    });
  }


}