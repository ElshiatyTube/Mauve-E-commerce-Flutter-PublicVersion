import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultTextButtonView extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final TextStyle textStyle;

  const DefaultTextButtonView(
      {Key? key, required this.function,
        required this.text,
        this.textStyle = const TextStyle(fontWeight: FontWeight.bold)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
