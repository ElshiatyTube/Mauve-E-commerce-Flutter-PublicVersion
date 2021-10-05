import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/product_details/product_details_cubit.dart';
import 'package:flutterecom/cubit/product_details/product_details_state.dart';
import 'package:flutterecom/shared/style/colors.dart';

class RadioItemTile extends StatelessWidget {
 final String title;
 final int value;
 final ValueChanged onChanged;

 const RadioItemTile({Key? key, required this.title, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  RadioListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      groupValue: ProductDetailsCubit.get(context).groupValue,
      onChanged: onChanged,
      title: Text(title,style: const TextStyle(color: MyColors.iconsColor),),
    );
  }
}
