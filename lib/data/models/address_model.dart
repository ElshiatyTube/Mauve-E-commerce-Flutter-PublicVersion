class AddressModel{
 late String addressName;
 late double lat,lng;

  AddressModel({required this.addressName, required this.lat, required this.lng});

  AddressModel.fromJson(Map<String,dynamic> json)
  {
    addressName = json['addressName'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'addressName':addressName,
      'lat':lat,
      'lng':lng,
    };
  }

}