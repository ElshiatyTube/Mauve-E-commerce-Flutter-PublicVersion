import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {

  @HiveField(0)
  late String id;
  @HiveField(1)
  late String firstName;
  @HiveField(2)
  late String lastName;
  @HiveField(3)
  late String email;


 /* Employee(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email
      });*/
}
