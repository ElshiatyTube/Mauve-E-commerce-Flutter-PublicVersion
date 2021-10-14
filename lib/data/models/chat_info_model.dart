class ChatInfoModel{
 late String createName,lastMessage;


 ChatInfoModel({required this.createName,required this.lastMessage});

  ChatInfoModel.fromJson(Map<String,dynamic> json)
 {
   createName =json['createName'];
   lastMessage =json['lastMessage'];

 }


 Map<String,dynamic> toMap()
 {
   return {
     'createName':createName,
     'lastMessage':lastMessage,

   };
 }
}