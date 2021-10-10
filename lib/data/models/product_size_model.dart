class ProductSizeModel {
  late String name,name_ar;
  late num price;


  ProductSizeModel({required this.name, required this.price,required this.name_ar});

  ProductSizeModel.fromJson(Map<String,dynamic> json)
  {
    name = json['name'];
    price = json['price'];
    name_ar = json['name_ar'];
  }
  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'price':price,
      'name_ar':name_ar,
    };
  }

}