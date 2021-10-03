import 'dart:math';

import 'address_model.dart';
class UserModel
{
  late String uId;
  late String name;
  late String phone;
  late String email;
  late List<AddressModel> address=[];
  late num  balance;


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
    };
  }


}