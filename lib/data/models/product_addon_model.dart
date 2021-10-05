class ProductAddonModel
{
 late String name,name_ar;
 late num price;
// bool value = false;



  ProductAddonModel.fromJson(Map<String,dynamic> json)
  {
    name = json['name'];
    name_ar = json['name_ar'];
    price = json['price'];
  }
  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'name_ar':name_ar,
      'price':price,
    };
  }
}