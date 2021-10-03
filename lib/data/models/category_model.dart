class CategoriesModel{
 String? menu_id='';
 late String name,name_ar,image;
 late List subCat;


 CategoriesModel(
 {this.menu_id, required this.name, required this.name_ar, required this.image, required this.subCat});

  CategoriesModel.fromJson(Map<String,dynamic> json)
  {
    menu_id = json['menu_id'];
    name = json['name'];
    name_ar = json['name_ar'];
    image = json['image'];


    if (json['subCat'] != null) {
      subCat = [];
      json['subCat'].forEach((v) {
        subCat.add(v);
      });
    }
  }
  Map<String,dynamic> toMap()
  {
    return {
      'menu_id':menu_id,
      'name':name,
      'name_ar':name_ar,
      'image':image,
      'subCat':subCat.map((e) => e.toString()).toList(),
    };
  }


}