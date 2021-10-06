import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterecom/data/models/product_addon_model.dart';
import 'package:flutterecom/data/models/product_rate_model.dart';
import 'package:flutterecom/data/models/product_size_model.dart';
class ProductModel{
  String? id='';
  late String name_ar;
  late String description_ar;
  String? subCat='';

  late String menu_id,name,image,description;
  late num price, oldPrice;
  late num ratingValue, ratingCount;
  late  bool availability;
   List<ProductSizeModel>? size;
   List<ProductAddonModel>? addon;

   List<ProductAddonModel>? userSelectedAddon;
   ProductSizeModel? userSelectedSize;
   //List<ProductRateModel> rates=[];
   DocumentReference? reference;


   ProductModel.fromJson(Map<String,dynamic> json)
   {
     id = json['id'];

     name = json['name'];
     if (json['name_ar'] != null) {
       name_ar = json['name_ar'];
     } else {
       name_ar = json['name'];
     }

     image = json['image'];
     availability = json['availability'];

     description = json['description'];
     if (json['description_ar'] != null) {
       description_ar = json['description_ar'];
     } else {
       description_ar = json['description'];
     }

     subCat = json['subCat'];
     menu_id = json['menu_id'];
     price = json['price'];
     oldPrice = json['oldPrice'];
     if(json['ratingValue'] != null){
       ratingValue = json['ratingValue'];
     }else{
       ratingValue = 0.1;
     }
     if(json['ratingCount'] != null){
       ratingCount = json['ratingCount'];
     }else{
       ratingCount = 0.1;
     }
     if (json['size'] != null) {
       size = <ProductSizeModel>[];
       json['size'].forEach((v) {
         size!.add(ProductSizeModel.fromJson(v));
       });
     }
     if (json['addon'] != null) {
       addon = <ProductAddonModel>[];
       json['addon'].forEach((v) {
         addon!.add(ProductAddonModel.fromJson(v));
       });
     }
     if (json['userSelectedAddon'] != null) {
       userSelectedAddon = <ProductAddonModel>[];
       json['userSelectedAddon'].forEach((v) {
         userSelectedAddon!.add(ProductAddonModel.fromJson(v));
       });
     }

     userSelectedSize = json['userSelectedSize'] != null ? ProductSizeModel.fromJson(json['userSelectedSize']) : null;

    /* if (json['rates'] != null) {
       rates = <ProductRateModel>[];
       json['rates'].forEach((v) {
         rates.add(ProductRateModel.fromJson(v));
       });
     }*/


   }
   Map<String,dynamic> toMap()
   {
     return {
       'id':id,
       'name':name,
       'name_ar':name_ar!='' ? name_ar : name,
       'image':image,
       'availability':availability,
       'description':description,
       'description_ar':description_ar!='' ? description_ar : description,
       'subCat':subCat,
       'menu_id':menu_id,
       'price':price,
       'oldPrice':oldPrice,
       'ratingValue':ratingValue!=0.1 ? ratingValue : 0.1,
       'ratingCount':ratingCount!=0.1 ? ratingCount : 0.1,
       'size':size!.map((e) => e.toMap()).toList(),
       'addon':addon!.map((e) => e.toMap()).toList(),
       'userSelectedAddon':userSelectedAddon!.map((e) => e.toMap()).toList(),
       'userSelectedSize':userSelectedSize,
       //this.userSelectedSize!=ProductSizeModel('',0,'') ?  'userSelectedSize':userSelectedSize.toMap() : null,
       //'rates':rates.map((e) => e.toMap()).toList(),


     };
   }
}