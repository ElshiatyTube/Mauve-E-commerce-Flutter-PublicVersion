import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {

  @HiveField(0)
  late String productId;
  @HiveField(1)
  late String uid;
  @HiveField(2)
  late String productName;
  @HiveField(3)
  late String productImage;
  @HiveField(4)
  late String productAddon;
  @HiveField(5)
  late String productSize;
  @HiveField(6)
  late double price;
  @HiveField(7)
  late int quantity;



 /* Employee(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email
      });*/
}
