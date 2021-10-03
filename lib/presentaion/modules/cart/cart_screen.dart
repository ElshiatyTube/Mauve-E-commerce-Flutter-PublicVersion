import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterecom/shared/network/local/hive/employee.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}


class _CartScreenState extends State<CartScreen> {


  @override
  void dispose() {
    // TODO: implement dispose
    Hive.box('employee').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {

                addEmployee(UniqueKey().hashCode.toString(), Faker().person.firstName(), Faker().person.lastName(), Faker().internet.email());

              /*  widget.dao.insertEmployee(employee).then((value) {
                  // showSnakBar(scaffoldKey.currentState, 'Add Success');
                  showToast(msg: 'Add Success!', state: ToastedStates.SUCCESS);
                  setState(() {

                  });
                });*/
              }),
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
              setState(() {
                Boxes.getEmployees().clear();
              });
              }),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Boxes.getEmployees().listenable(),
        builder: (context,Box box, _) {
          final transactions = box.values.toList().cast<Employee>();

          return buildContent(transactions);
        },
      ),
    );
  }


  //Add
  Future<void> ?addEmployee(String id,String firstName,String lastName,String email) {
    final employee = Employee()
        ..firstName =firstName
        ..id = id
        ..lastName=lastName
        ..email=email;

    final box = Boxes.getEmployees();
    box.put(id, employee).then((value) => print('Add Success'));
    // box.add(employee).then((value) => print('Add Success'));

 //   final myBox = Boxes.getEmployees();
  //  final myEmployeer = myBox.get(id);
   // myBox.values;
    //myBox.keys;
  }

  //Update
  void updateEmployeee(Employee employee,String firstName,String lastName,String email ){

    employee.firstName = firstName;
    employee.lastName = lastName;
    employee.email = email;

    // final box = Boxes.getTransactions();
    // box.put(transaction.key, transaction);

    employee.save();

  }

  //Delete
  void deleteEmployeee(Employee employee) {
    // final box = Boxes.getTransactions();
    // box.delete(transaction.key);

    employee.delete();

    //setState(() => transactions.remove(transaction));
  }
  Widget buildContent(transactions) {
    return ListView.separated(
      itemCount: transactions != null ? transactions.length : 0,
      itemBuilder: (context, index) {
        return Slidable(
          child: ListTile(
            title: Text(
                '${transactions[index].firstName} ${transactions[index].lastName}'),
            subtitle: Text('${transactions[index].email}'),
          ),
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: 'Update',
              color: defaultColor,
              icon: Icons.update,
              onTap: (){
                final Employee updateEmployee = transactions[index];
                updateEmployeee(updateEmployee, 'Watter', updateEmployee.lastName, 'yusuf4iaty@gmail.com');

              },
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.remove_circle_outline,
              onTap: (){
                final deleteEmployee = transactions[index];

                deleteEmployeee(deleteEmployee);

              },
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Container(
            width: double.infinity, height: 1.0, color: Colors.grey[300],
          ),
    );
  }
}

class Boxes {
  static Box<Employee> getEmployees() => Hive.box<Employee>('employee');
}
