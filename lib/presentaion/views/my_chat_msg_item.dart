import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/data/models/chat_msg_model.dart';

class MyChatMsgItem extends StatelessWidget {
  final ChatMsgModel chatMsgModel;
  const MyChatMsgItem({Key? key, required this.chatMsgModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(
              10.0,
            ),
            topStart: Radius.circular(
              10.0,
            ),
            topEnd: Radius.circular(
              10.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 7.0,
          horizontal: 14.0,
        ),
        child: Text(
          chatMsgModel.content,
        ),
      ),
    );
  }
}
