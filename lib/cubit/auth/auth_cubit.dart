import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/data/models/address_model.dart';
import 'package:flutterecom/data/models/token_model.dart';
import 'package:flutterecom/data/models/user_model.dart';


import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:one_context/one_context.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  static AuthCubit get(context) => BlocProvider.of(context);

  Location location = Location();
  late final LocationData _locationData;
  late final bool _serviceEnable;
  late final PermissionStatus _permissionGranted;
  bool _isListenLocation = false,_isGetLocation=false;


  void uerLogin({required String email, required String password}) {
    emit(LoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      checkUserExistInDatabase(uid: value.user!.uid, phone: '', email: '');
    }).catchError((onError) {
      emit(LoginFailedState(onError.toString()));
    });
  }

   UserModel userModel = UserModel(name: '',phone: '',email: '',uId: '',balance: 0.1,address: []);

  void checkUserExistInDatabase({
    required String uid,
    required phone,
    required email,
  }) {
    print('uIDD: ${uid}');
    FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        print('Account exist Go to ShopLayout');
        userModel = UserModel.fromJson(value.data()!);
        emit(LoginSuccessState(userModel));
      } else {
        emit(LoginSuccessStateButNeedRegister(phone!,email!));
        print('Account Not exist Go to Register');
      }
    }).catchError((onError) {
      emit(LoginFailedState(onError.toString()));
      print('ErroNO: ${onError.toString()}');
    });
  }

  IconData suffix = Icons.remove_red_eye_outlined;
  bool isPass = true;

  void changePassVisibility() {
    isPass = !isPass;
    suffix =
        isPass ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined;

    emit(PassVisibilityState());
  }

  void changeLang(BuildContext context) {
    if (context.locale.toString().contains('en')) {
      // context.locale = Locale('ar', 'AR');
      context.setLocale(const Locale('ar', 'AR'));
      print(context.locale.toString());
      print('DeviceLocal: ${context.deviceLocale.toString()}'); // OUTPUT: en_US
      emit(ChangeLang());
    } else {
      //context.locale = Locale('en', 'EN');
      context.setLocale(const Locale('en', 'EN'));
      print(context.locale.toString());
      print('DeviceLocal: ${context.deviceLocale.toString()}'); // OUTPUT: en_US
      emit(ChangeLang());
    }
  }


  //Register
  void userRegister({
    required String name,
    required String email,
    required String address,
    String? password,
    required String phone,
  }) {

    emit(RegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password!,
    ).then((value)  {

      print('UserEmailFire: ${value.user!.email}');
      print(value.user!.uid);
      userCreate(name: name,
        email: email,
        uId: value.user!.uid,
        phone: phone,
        address: address,
      );

    }).catchError((onError){
      print(onError.toString());
      showToast(msg: onError.toString(), state: ToastedStates.WARNING);
      emit(RegisterFailedState(onError.toString()));
    });

  }

  List<AddressModel> userAddressModelList=[];
  void userCreate({
    required String name,
    required String email,
    required String address,
    required String uId,
    required String phone,
  })
  {
    emit(RegisterLoadingState());

    location.serviceEnabled().then((value) {
      if(!value) {
        location.requestService().then((value) {
          _serviceEnable = value;
        });
      }
      if(value) return;
    }).catchError((onError){
      print(onError.toString());
      showToast(msg: onError.toString(), state: ToastedStates.WARNING);
      emit(RegisterFailedState(onError.toString()));
    });
    location.hasPermission().then((value) {
      if(value ==PermissionStatus.denied) {
        location.requestPermission().then((value) {
          _permissionGranted = value;
        });
      }
      if(value !=PermissionStatus.granted) return;
    }).catchError((onError){
      print(onError.toString());
      showToast(msg: onError.toString(), state: ToastedStates.WARNING);
      emit(RegisterFailedState(onError.toString()));
    });


    location.getLocation().then((value) {
      _locationData =value;
      _isGetLocation=true;
      print('Location is: lat:${_locationData.latitude} lng:${_locationData.longitude}');

      userAddressModelList.add(AddressModel(
        addressName: address,
        lat: _locationData.latitude!,
        lng: _locationData.longitude!,
      ));

      UserModel userModelCreate= UserModel(
        name: name,
        uId: uId,
        email :email,
        phone:phone,
        address: userAddressModelList,
        balance: 0,
      );

      FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(uId)
          .set(userModelCreate.toMap())
          .then((value) {
        userModel  = userModelCreate;
       // updateToken(uId);


        emit(CreateUserSuccessState(userModelCreate));
      }).catchError((onError){
        emit(CreateUserFailedState(onError.toString()));
      });


    }).catchError((onError){
      print(onError.toString());
      emit(CreateUserFailedState(onError.toString()));
    });




  }

  //Phone Auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late String globalVerificationId;

  void phoneAuth(String phone, BuildContext context,String title){
    emit(ShopLoginPhoneAuthLoading());

    auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential){
        auth.signInWithCredential(credential).then((value) {
          print('Ver Comp ${value.user!.phoneNumber} ${value.user!.email}');
          phoneOrEmailUid = value.user!.uid;
          phoneLoginPhoneNum = value.user!.phoneNumber!;
          emit(ShopLoginLoadingDoneTypeOTB(value.user!.uid, value.user!.phoneNumber!,''));

        }).catchError((onError){
          print(onError.toString());
          emit(ShopLoginFailedOTB(onError.toString()));
          showToast(msg: 'WARNING ${onError.toString()}', state: ToastedStates.WARNING);
        });

      },
      verificationFailed:(exception){
        print('Num WARNING ${exception}');
        showToast(msg: 'wrong_num'.tr(), state: ToastedStates.WARNING);
        emit(ShopLoginFailedOTB(onError.toString()));
      },
      codeAutoRetrievalTimeout: (String verificationId){
        verificationId = verificationId;
        print(verificationId);
        print("TimeOut");
      },
      codeSent: (String verificationId, [int? forceResendingToken]){
        globalVerificationId = verificationId;
        emit(ShopLoginPhoneCodeSuccessSend(phone));


      },
    );
  }

   String phoneOrEmailUid='';
   String phoneLoginPhoneNum='';
   String googleLLoginEmail='';


  void submitOTP(String otpCode) {
    emit(SubmitOptLoading());
    print('otpCode ${otpCode}');
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: globalVerificationId, smsCode: otpCode);

    auth.signInWithCredential(credential).then((value) {

      if(value.user!=null)
      {
        phoneOrEmailUid = value.user!.uid;
        phoneLoginPhoneNum = value.user!.phoneNumber!;

        checkUserExistInDatabase(uid: value.user!.uid,phone: value.user!.phoneNumber, email: '');
      }else{
        showToast(msg: 'login_wrong'.tr(), state: ToastedStates.WARNING);
        emit(ShopLoginFailedOTB(onError.toString()));
      }

    }).catchError((onError){
      print('${onError.toString()}');
      showToast(msg: 'login_wrong'.tr(), state: ToastedStates.WARNING);
      emit(ShopLoginFailedOTB(onError.toString()));
    });


  }

  void signInByGoogle() {
    emit(GoogleSingUpLoading());

    _googleSignIn.signIn().then((googleSignInAccount) {
      googleSignInAccount!.authentication.then((googleSignInAuthentication) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        auth.signInWithCredential(credential).then((value) {
          if(value.user!=null)
            {
              phoneOrEmailUid = value.user!.uid;
              googleLLoginEmail = value.user!.email!;
              checkUserExistInDatabase(uid: value.user!.uid,email: value.user!.email, phone: '');
            }
          else{
            showToast(msg: 'login_wrong'.tr(), state: ToastedStates.WARNING);
            emit(GoogleSingUpFailed(onError.toString()));
          }
        });
      });
    });

  }

  Future<void> signOut(BuildContext context) async{
    if(_googleSignIn.currentUser!=null){
      await _googleSignIn.signOut();
    }
    Boxes.getEmployees().clear();
    CacheHelper.removeData(key: 'uId');
    await auth.signOut();
    OneNotification.hardReloadRoot(context);

  }

  //Update User Info
  void updateUserData({required String name,required String phone,required String email}) {
    emit(UserInfoUpdateLoading());

    Map<String, dynamic> update = {};
    update['name'] = name;
    update['phone'] = phone;
    update['email'] = email;

    FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .doc(userModel.uId)
        .update(update).then((value) {
      userModel.phone = phone;
      userModel.name = name;
      userModel.email = email;
      emit(UserInfoUpdateSuccess());
    }).catchError((onError){
      emit(UserInfoUpdateFailed(onError.toString()));
    });
  }

  File? profileImage ;
  final picker = ImagePicker();

  Future pickProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(ProfileImagePickedFailedState());
    }
  }
  void uploadProfileImage() {
    emit(UserImageUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('usersImages/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        Map<String, dynamic> updateImage = {};
        updateImage['image'] = imageUrl;
        FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .doc(userModel.uId)
            .update(updateImage).then((value){
          userModel.image = imageUrl;
        emit(UploadProfileInFirebaseSuccessState());
        }).catchError((onError){
          emit(SocialUploadProfileImageFailedState());
        });
        print(value);
      }).catchError((onError) {
        emit(SocialUploadProfileImageFailedState());
      });
    }).catchError((onError) {
      emit(SocialUploadProfileImageFailedState());
    });
  }



}
