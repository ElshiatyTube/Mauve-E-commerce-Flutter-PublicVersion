class ProductRateModel{
 late String comment,name,uid,itemName,itemId;
 late String commentTime;
 late num ratingValue;


  ProductRateModel({required this.comment, required this.name, required this.uid, required this.itemName,
    required this.itemId, required this.commentTime, required this.ratingValue});

  ProductRateModel.fromJson(Map<String,dynamic> json)
  {
    comment = json['comment'];
    name = json['name'];
    uid = json['uid'];
    itemName = json['itemName'];
    itemId = json['itemId'];
    commentTime = json['commentTime'];
    ratingValue = json['ratingValue'];
  }
  Map<String,dynamic> toMap()
  {
    return {
      'comment':comment,
      'name':name,
      'uid':uid,
      'itemName':itemName,
      'itemId':itemId,
      'commentTime':commentTime,
      'ratingValue':ratingValue,
    };
  }

}