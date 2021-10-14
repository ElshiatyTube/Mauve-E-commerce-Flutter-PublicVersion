import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/user_address/user_address_cubit.dart';
import 'package:flutterecom/cubit/user_address/user_address_state.dart';
import 'package:flutterecom/presentaion/views/user_address_item.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton( //I:\DexkTop Old lap\5amsat\flutter_ecom
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onPrimary: Colors.transparent,
                shadowColor: Colors.transparent,
                onSurface: Colors.transparent,
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
              ),
              onPressed: () {
                UserAddressCubit.get(context).navigateToPlacePicker(context: context);
              },
              child: Row(
                children: const [
                  Icon(
                    Iconly_Broken.Plus,
                    color: defaultColor,
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    'New Address',
                    style: TextStyle(color: defaultColor, fontSize: 13.0),
                  ),
                ],
              )),
        ],
        leading: IconButton(
          icon: Icon(
            context.locale.toString() == 'en_EN'
                ? Iconly_Broken.Arrow___Left_2
                : Iconly_Broken.Arrow___Right_2,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<UserAddressCubit, UserAddressState>(
        listener: (context, state) {
          if(state is PickedPlaceSuccess){
            Navigator.pop(context);
            UserAddressCubit.get(context).showAddNewUserAddressDialog(lat: state.lat,lng: state.lng,formattedAddress: state.formattedAddress,context: context);
          }
          if(state is UpdateAddressTextSuccessState){
            showToast(msg: 'AddedSuccessfully', state: ToastedStates.SUCCESS,);
          }
          if(state is UpdateAddressTextFailedState){
            showToast(msg: state.error, state: ToastedStates.SUCCESS,);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.width,
                          height: 110,
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/addressbanner.jpg?alt=media&token=29db89f7-d285-4d6a-bc93-494053669262',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                          0.4,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Text(
                        'We are close to you',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                state is UpdateAddressLocLoadingState ? defaultLinearProgressIndicator() : Container(),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => UserAddressItem(
                        addressItem:
                            AuthCubit.get(context).userModel.address[index],
                        currentIndex: index),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                    itemCount: AuthCubit.get(context).userModel.address.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
