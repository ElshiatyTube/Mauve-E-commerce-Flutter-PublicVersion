import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/chat/chat_cubit.dart';
import 'package:flutterecom/cubit/chat/chat_state.dart';
import 'package:flutterecom/data/models/chat_msg_model.dart';
import 'package:flutterecom/presentaion/views/admin_chat_msg_item.dart';
import 'package:flutterecom/presentaion/views/my_chat_msg_item.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';

class ChatScreen extends StatefulWidget {

  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ChatCubit.get(context).getMessages();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          titleSpacing: 0.0,
          title: const Text('Mohamed, Customer Services'),
        leading: IconButton(
          icon: Icon(
            context.locale.toString() == 'en_EN'
                ? Iconly_Broken.Arrow___Left_2
                : Iconly_Broken.Arrow___Right_2,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context,state){
          if(state is ChatSendMessageSuccessState){
            messageController.text ='';
          }
        },
        builder: (context,state){
        /*  if (_controller.hasClients){
            _controller.animateTo(_controller.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
          }*/
            return ConditionalBuilder(
            condition: ChatCubit.get(context).messages!=null,
            builder: (BuildContext context)
            {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children:
                  [
                    Expanded(
                      child: ListView.separated(
                        controller: _controller,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context,index)
                        {
                          final reversedIndex = ChatCubit.get(context).messages!.length - 1 - index;
                          final item = ChatCubit.get(context).messages![reversedIndex];

                          ChatMsgModel message = item;

                          if(CacheHelper.getString(key: 'uId') == message.uid) {
                            return MyChatMsgItem(chatMsgModel: message);
                          }
                          return AdminChatMsgItem(chatMsgModel: message);
                        },
                        separatorBuilder: (context,index) => const SizedBox(height: 15.0,),
                        itemCount: ChatCubit.get(context).messages!.length,
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.iconsBgColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0,),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 7.0,),
                              child: TextFormField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type yor msg...'),
                              ),
                            ),
                          ),
                          Container(
                            height: 48.0,
                            decoration: const BoxDecoration(
                              color: defaultColor,
                              borderRadius:BorderRadius.all( Radius.circular(5.0,)),
                            ),
                            child: MaterialButton(
                              onPressed: ()
                              {
                                if(messageController.text.isNotEmpty){
                                  ChatCubit.get(context).sendMsg
                                    (
                                    dateTime: DateTime.now().millisecondsSinceEpoch,
                                    content: messageController.text, name: AuthCubit.get(context).userModel.name,
                                  );
                                }

                              },
                              minWidth: 1.0,
                              child: const Icon(
                                Iconly_Broken.Send,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            fallback:(context) => const Center(child: CircularProgressIndicator()),

          );
        },
      ),
    );
  }
}
