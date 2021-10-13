import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/user_address/user_address_state.dart';
import 'package:flutterecom/data/models/address_model.dart';
import 'package:flutterecom/presentaion/dialogs/add_user_address_dialog.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class UserAddressCubit extends Cubit<UserAddressState>{
  UserAddressCubit() : super(UserAddressInitState());

  static UserAddressCubit get(context) => BlocProvider.of(context);


  void navigateToPlacePicker({
    required BuildContext context,
  }){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlacePicker(
              apiKey: GOOGLE_MAP_API_KEY,
              region: 'EG',
              searchingText: 'Search...',
              enableMapTypeButton: false,
              onPlacePicked: (PickResult result) {
                print('ResultPicked: ${result.formattedAddress}');
                emit(PickedPlaceSuccess(lat: result.geometry!.location.lat,lng: result.geometry!.location.lng,formattedAddress: result.formattedAddress.toString()));
              },
              initialPosition: const LatLng(30.036816, 31.503930),
              useCurrentLocation: true,
            ),
      ),
    );
  }

  void showAddNewUserAddressDialog({required double lat,required double lng,required String formattedAddress,required BuildContext context}){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:(context) => AddUserAddressDialog(lat:lat,lng:lng,formattedAddress: formattedAddress),
    );

  }

  void addNewUserAddress({required String addressText,required double lng,required double lat,required BuildContext context}){
    var addressModel = AddressModel(addressName: addressText,lng: lng,lat: lat);
    AuthCubit.get(context).userModel.address.add(addressModel);

    emit(UpdateAddressLocLoadingState());
    Navigator.of(context).pop();

    FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .doc(AuthCubit.get(context).userModel.uId)
        .update(AuthCubit.get(context).userModel.toMap())
        .then((value) {
      emit(UpdateAddressTextSuccessState());

    }).catchError((onError){
      emit(UpdateAddressTextFailedState(onError.toString()));
    });
  }

  void removeUserLocation({required BuildContext context,required int addressIndex}) {

    if(AuthCubit.get(context).userModel.address.length == 1) {
      showToast(msg: "Sorry You must have at least one address",
          state: ToastedStates.WARNING);
    }
    else{
      emit(RemoveAddressItemLoadingState());

      AuthCubit.get(context).userModel.address.removeAt(addressIndex);

      FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(AuthCubit.get(context).userModel.uId)
          .update(AuthCubit.get(context).userModel.toMap())
          .then((value) {
        emit(RemoveAddressItemSuccessState());
        showToast(msg: 'Address Removed Successfully', state: ToastedStates.SUCCESS,);
      }).catchError((onError){
        emit(RemoveAddressItemFailedState(onError.toString()));

      });
    }

  }
}