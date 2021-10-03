import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/shared/style/colors.dart';

class ElevatedButtonView extends StatelessWidget {
  final Color bgColor;
  final String text;
  final VoidCallback function;

  const ElevatedButtonView({
    Key? key,
    required this.text,
    required this.function,
    this.bgColor = blackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(text, style: const TextStyle(color: Colors.white),),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bgColor),
      ),
    );
  }
}
