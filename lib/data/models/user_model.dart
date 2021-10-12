import 'dart:math';

import 'address_model.dart';
class UserModel
{
  late String uId;
  late String name;
  late String phone;
  late String email;
  late String image;
  late List<AddressModel> address=[];
  late num  balance;
  late bool emailBol,phoneBol;


  UserModel({required this.uId,required this.name,required this.phone,required this.email,required this.address,required this.balance});

  UserModel.fromJson(Map<String,dynamic> json)
   {
     uId = json['uId'];
     name = json['name'];
     phone = json['phone'];
     email = json['email'];
     if (json['address'] != null) {
       address = <AddressModel>[];
       json['address'].forEach((v) {
         address.add(AddressModel.fromJson(v));
       });
     }
     balance= json['balance'];
     emailBol= json['emailBol'];
     phoneBol= json['phoneBol'];
     image= json['image'];
   }
  Map<String,dynamic> toMap()
  {
    return {
      'uId':uId,
      'name':name,
      'phone':phone,
      'email':email,
      'address':address.map((e) => e.toMap()).toList(),
      'balance':balance,
      'emailBol':emailBol,
      'phoneBol':phoneBol,
      'image':image,
    };
  }


}