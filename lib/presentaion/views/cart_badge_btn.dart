import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/cart/cart_cubit.dart';
import 'package:flutterecom/cubit/cart/cart_state.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/hive/employee.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartBadgeBtn extends StatelessWidget {
  const CartBadgeBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: Boxes.getEmployees().listenable(),
      builder: (context,Box box, _) {
        final int cartItemsLength = box.values.toList().cast<Employee>().length;
        return InkWell(
          onTap: (){
            if(cartItemsLength!=0){
              Navigator.pushNamed(context, cartPath);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Badge(
              badgeContent: Text(
                '$cartItemsLength',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              position: BadgePosition.topStart(top: 1, start: 8),
              badgeColor: defaultColor,
              child: const Icon(
                Iconly_Broken.Buy,
                color: MyColors.iconsColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
