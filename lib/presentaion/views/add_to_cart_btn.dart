import 'package:flutter/cupertino.dart';
import 'package:flutterecom/shared/style/colors.dart';

class AddToCartBTN extends StatelessWidget {
  const AddToCartBTN({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: defaultColor,
          width: 1.3,
        ),
        borderRadius: const BorderRadius.all(
            Radius.circular(10.0)
        ),
      ),
      child: const Padding(
        padding:  EdgeInsets.only(right: 28.0,left: 28.0,top: 7.0,bottom: 7.0),
        child:  Text('Add To Cart',style: TextStyle(color: defaultColor),),
      ),
    );
  }
}
