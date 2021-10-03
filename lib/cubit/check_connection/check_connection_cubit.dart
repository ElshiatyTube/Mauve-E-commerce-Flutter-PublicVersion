import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/check_connection/check_connection_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutterecom/presentaion/views/elevated_btn.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:one_context/one_context.dart';

class CheckConnectionCubit extends Cubit<CheckConnectionStates> {
  CheckConnectionCubit(): super (CheckConnectionLoading());

  static CheckConnectionCubit get(context)=> BlocProvider.of(context);


  final _connectivity = Connectivity();
  bool? hasConnection;



  Future<void> initializeConnectivity() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    _checkConnection(await _connectivity.checkConnectivity());
  }

  void _connectionChange(ConnectivityResult result) {
    _checkConnection(result);
  }

  Future<bool?> _checkConnection(ConnectivityResult result) async {
    bool? previousConnection;
    if (kIsWeb) {
      hasConnection = true;
      _connectionChangeController(hasConnection!);
    }
    if(hasConnection!=null){
      previousConnection = hasConnection!;
    }

    if (result == ConnectivityResult.none) {
      hasConnection = false;
      if (previousConnection != hasConnection) {
        _connectionChangeController(hasConnection!);
      }
      return hasConnection;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        if (hasConnection == null) {
          hasConnection = false;
          _connectionChangeController(hasConnection!);
        }
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      _connectionChangeController(hasConnection!);
    }

    return hasConnection;
  }

  bool isNetDialogShow =false;

  void _connectionChangeController(bool _hasConnection){

    if(_hasConnection){
      emit(InternetConnected());
    }else{
      emit(InternetDisconnected());
    }
    //showInternetDialog(canDismiss: false,isConnected: _hasConnection);
  }



/*
  void showInternetDialog({required bool canDismiss, required bool isConnected}){

    if(!isConnected){
      emit(InternetDisconnected());
      isNetDialogShow = true;
      OneContext().showDialog(
          barrierDismissible: canDismiss ? true : false,
          builder: (_) => WillPopScope(
            onWillPop: () async {  return canDismiss ? true : false; },
            child: AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.not_interested),
                  Text('not_net_title'.tr(),style: const TextStyle(fontSize: 20.0),)
                ],
              ),
              content: Text('not_net_msg'.tr(),style: const TextStyle(fontSize: 14.0,color: Colors.grey),),
            ),
          ),
      );

    }
    else{
      emit(InternetConnected());
      if(isNetDialogShow)
      {
        OneContext().popDialog();
        isNetDialogShow = false;

      }
    }

  }
*/




}
