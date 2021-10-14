class ChatMsgModel{
 late String uid,name,content;
 late num timeStamp;

 ChatMsgModel({required this.uid,required this.name,required this.content, required this.timeStamp});

 ChatMsgModel.fromJson(Map<String,dynamic> json)
 {
   uid =json['uid'];
   name =json['name'];
   content =json['content'];
   timeStamp =json['timeStamp'];
 }


 Map<String,dynamic> toMap()
 {
   return {
     'uid':uid,
     'name':name,
     'content':content,
     'timeStamp':timeStamp,
   };
 }
}