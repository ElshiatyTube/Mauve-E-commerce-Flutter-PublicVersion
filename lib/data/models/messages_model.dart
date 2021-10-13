class MessagesModel {
  String? uid = '';
  late String name, phone, msg;
  late num time;

  MessagesModel(this.uid, this.name, this.phone, this.msg, this.time);

  MessagesModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    phone = json['phone'];
    msg = json['msg'];
    time = json['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'msg': msg,
      'time': time,
    };
  }
}
