import 'package:flutter/cupertino.dart';
import 'package:flutterecom/data/models/chat_msg_model.dart';
import 'package:flutterecom/shared/style/colors.dart';

class AdminChatMsgItem extends StatelessWidget {
  final ChatMsgModel chatMsgModel;
  const AdminChatMsgItem({Key? key, required this.chatMsgModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        decoration: BoxDecoration(
          color: defaultColor.withOpacity(
            .2,
          ),
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(
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
