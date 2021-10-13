import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/cubit/user_address/user_address_cubit.dart';
import 'package:flutterecom/data/models/address_model.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';

class UserAddressItem extends StatelessWidget {
  final AddressModel addressItem;
  final int currentIndex;

  const UserAddressItem(
      {Key? key, required this.addressItem, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      //expandedAlignment: Alignment.topLeft,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: const Icon(
              Iconly_Broken.Location,
              color: MyColors.iconsColor,
            ),
            decoration: BoxDecoration(
              color: MyColors.iconsBgColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(5.0),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Expanded(
              child: Text(
            addressItem.addressName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 25.0,right: 25.0
          ),
          child: Column(
            children: [
              Text(
                addressItem.addressName,
              ),
              Align(
                child: InkWell(
                  onTap: (){
                    UserAddressCubit.get(context).removeUserLocation(context: context,addressIndex: currentIndex);
                  },
                    child: const Icon(
                  Iconly_Broken.Delete,
                  color: defaultColor,
                  ),
                ),
                alignment: Alignment.bottomRight,
              ),
              const SizedBox(height: 5.0,),
            ],
          ),
        ),
      ],
    );
  }
}
