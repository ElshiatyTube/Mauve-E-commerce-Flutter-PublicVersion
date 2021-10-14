abstract class ChatState{}

class ChatInitState extends ChatState{}

class ChatGetMessageSuccessState extends ChatState{}

//Send
class ChatSendMessageSuccessState extends ChatState{}
class ChatSendMessageFailedState extends ChatState{
  final String error;

  ChatSendMessageFailedState(this.error);
}

