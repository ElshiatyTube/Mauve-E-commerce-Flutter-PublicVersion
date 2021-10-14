import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/data/models/chat_info_model.dart';
import 'package:flutterecom/data/models/chat_msg_model.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState>{
  ChatCubit() : super(ChatInitState());

  static ChatCubit get(context) => BlocProvider.of(context);


  List<ChatMsgModel>? messages;

  void getMessages()
  {
    FirebaseFirestore.instance
        .collection(CHAT_REF)
        .doc(generateChatRoomId('',CacheHelper.getString(key: 'uId')))
        .collection(CAHT_DETAIL_REF)
        .orderBy('timeStamp')
        .snapshots()
        .listen((event)
    {
      messages=[];

      event.docs.forEach((element)
      {
        messages!.add(ChatMsgModel.fromJson(element.data()));
      });
      emit(ChatGetMessageSuccessState());
    });
  }

  String generateChatRoomId(String a,String b){
    if(a.compareTo(b) > 0){
      return '$a$b';
    }
    else if(a.compareTo(b) < 0){
      return '$b$a';
    }
    else{
      return 'ChatYourSelf_ERROR_';
    }
  }



  void sendMsg({
    required String content,
    required String name,
    required num dateTime,
  })
   {
    ChatMsgModel messageModel=ChatMsgModel(content: content, name: name, timeStamp: dateTime, uid: CacheHelper.getString(key: 'uId'));

    ChatInfoModel chatInfoModel = ChatInfoModel(lastMessage: content,createName: name );

    FirebaseFirestore.instance
        .collection(CHAT_REF)
        .doc(generateChatRoomId('',CacheHelper.getString(key: 'uId')))
    .set(chatInfoModel.toMap()).then((value) {

      //set my chat
      FirebaseFirestore.instance
          .collection(CHAT_REF)
          .doc(generateChatRoomId('',CacheHelper.getString(key: 'uId')))
          .collection(CAHT_DETAIL_REF)
          .add(messageModel.toMap())
          .then((value)
      {
        emit(ChatSendMessageSuccessState());
      }).catchError((onError){
        emit(ChatSendMessageFailedState(onError.toString()));
      });

    });


  }

}