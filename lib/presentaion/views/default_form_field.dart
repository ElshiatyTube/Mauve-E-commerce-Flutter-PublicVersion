import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/shared/style/colors.dart';

class DefaultFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final ValueChanged<String>? onSubmit;
  final ValueChanged<String>? onChanged;
  final Color bgColor;
  final String hint ;
  final bool isDense;
  final bool isPassword ;
  final FormFieldValidator<String> validator;
  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? suffixIconPressed;
  final VoidCallback? onTap;
  bool isClickable;

   DefaultFormField(
      {Key? key,
      required this.controller,
        required this.textInputType,
        this.onSubmit,
      this.onChanged,
        required this.validator,
        required this.label,
        required this.prefixIcon,
      this.suffixIcon,
      this.suffixIconPressed,
        this.isPassword = false,
        this.isClickable =true,
        this.hint ='',
      this.onTap, this.isDense = false, this.bgColor=MyColors.scaffoldBackgroundColorMain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const InputDecorationTheme defaultTheme = InputDecorationTheme();

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: bgColor,
          hintText: hint,
          labelText: label,
          //hintText
          prefixIcon: Icon(
            prefixIcon,
            color: MyColors.iconsColor,
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
            icon:
            isDense ? Container(
              decoration:BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.circular(5.0),
              ),
              child: Icon(
                suffixIcon,
                color: MyColors.iconsColor,
              ),
            ) : Icon(
              suffixIcon,
              color: MyColors.iconsColor,
            ),
            onPressed: suffixIcon != null ? suffixIconPressed : null,
          )
              : null,
          enabledBorder: isDense ? const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(color: Colors.white, width: 0.0),
          ) : defaultTheme.enabledBorder,
          border:  OutlineInputBorder(borderRadius:isDense? BorderRadius.circular(15.0)  : BorderRadius.circular(5.0),),
         isDense: isDense,                      // Added this
         contentPadding:isDense?const EdgeInsets.all(8): defaultTheme.contentPadding ,  // Added this
      ),
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      validator: validator,
      keyboardType: textInputType,
      obscureText: isPassword,
      onTap: onTap,
      enabled: isClickable,


    );
  }
}

