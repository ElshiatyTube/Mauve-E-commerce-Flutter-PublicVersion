class TokenModel {
 late String phone, token;
 late bool serverToken, shipperToken;

  TokenModel(this.phone, this.token, this.serverToken, this.shipperToken);

  TokenModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    token = json['token'];
    serverToken = json['serverToken'];
    shipperToken = json['shipperToken'];
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'token': token,
      'serverToken': serverToken,
      'shipperToken': shipperToken,
    };
  }
}
