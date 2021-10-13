import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/cubit/user_address/user_address_cubit.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:flutterecom/shared/validator.dart';

class AddUserAddressDialog extends StatefulWidget {
  final double lat,lng;
  final String formattedAddress;

  AddUserAddressDialog({Key? key, required this.lat, required this.lng, required this.formattedAddress}) : super(key: key);

  @override
  State<AddUserAddressDialog> createState() => _AddUserAddressDialogState();
}

class _AddUserAddressDialogState extends State<AddUserAddressDialog> {
  var addressController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addressController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressController.text = widget.formattedAddress;
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title:  Row(
        children: [
          const Icon(Iconly_Broken.Location),
          Text('New Address',style: Theme.of(context).textTheme.bodyText1,),
        ],
      ),
      content: Form(
        key: formKey,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: TextFormField(
                maxLines: 6,
                keyboardType: TextInputType.text,
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter the full address',
                  border: InputBorder.none,
                ),
                validator: Validator.validateAddress,
              ),
            ),
          ],
        ),
      ),
      actions:[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child:const Text('Cancel',style: TextStyle(color: Colors.red),),
        ),
        TextButton(
          onPressed: () {
            if(formKey.currentState!.validate())
            {
              UserAddressCubit.get(context).addNewUserAddress(lat: widget.lat,lng: widget.lng,addressText: addressController.text, context: context);
            }
          },
          child: const Text('Add',style: TextStyle(color: Colors.green),),
        ),
      ],
    );
  }
}
