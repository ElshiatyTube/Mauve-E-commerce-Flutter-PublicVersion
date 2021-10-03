import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/shared/style/colors.dart';

class ElevatedButtonIconView extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final double elevation;
  final Widget icon;
  final String text;
  final VoidCallback function;
  const ElevatedButtonIconView(
      {Key? key,
       required this.icon,
       required this.text,
       required this.function,
        this.bgColor = blackColor,this.textColor=Colors.white, this.elevation = 1.5
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: function,
      icon: icon,
      label: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(text, style: TextStyle(color: textColor),),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bgColor),
        elevation: MaterialStateProperty.all(elevation),
      ),

    );
  }
}
