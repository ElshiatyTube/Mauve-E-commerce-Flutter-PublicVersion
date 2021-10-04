class ProductAddonModel
{
 late String name;
 late num price;
 late bool value;

  ProductAddonModel({required this.name, required this.price, this.value=false});

  ProductAddonModel.fromJson(Map<String,dynamic> json)
  {
    name = json['name'];
    price = json['price'];
    value = false;
  }
  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'price':price,
      'value':false,
    };
  }
}