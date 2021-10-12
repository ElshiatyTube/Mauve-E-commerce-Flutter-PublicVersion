

import 'package:flutterecom/data/models/user_model.dart';

abstract class AuthStates {}

class AuthInitState extends AuthStates {}


class PassVisibilityState extends AuthStates{}
class ChangeLang extends AuthStates{}


//Login
class LoginLoadingState extends AuthStates {}
class LoginSuccessState extends AuthStates
{
  final UserModel userModel;

  LoginSuccessState(this.userModel);
}
class LoginFailedState extends AuthStates {
  final String error;

  LoginFailedState(this.error);
}

class LoginSuccessStateButNeedRegister extends AuthStates {
  final String phone,email;

  LoginSuccessStateButNeedRegister(this.phone,this.email);
}



//Register
class RegisterLoadingState extends AuthStates {}
class RegisterSuccessState extends AuthStates
{
  final UserModel userModel;
  RegisterSuccessState(this.userModel);
}
class RegisterFailedState extends AuthStates {
  final String error;

  RegisterFailedState(this.error);
}


class CreateUserSuccessState extends AuthStates
{
  final UserModel userModel;
  CreateUserSuccessState(this.userModel);
}
class CreateUserFailedState extends AuthStates {
  final String error;

  CreateUserFailedState(this.error);
}


//Phone Auth
class ShopLoginPhoneAuthLoading extends AuthStates {}
class ShopLoginPhoneCodeSuccessSend extends AuthStates {
  final String phone;

  ShopLoginPhoneCodeSuccessSend(this.phone);
}
class ShopLoginPhoneAuthFailed extends AuthStates {}
class ShopLoginLoadingDoneTypeOTB extends AuthStates {
  final String uId,phone,email;

  ShopLoginLoadingDoneTypeOTB(this.uId, this.phone,this.email);
}
class ShopLoginFailedOTB extends AuthStates {
  final String error;

  ShopLoginFailedOTB(this.error);
}
class SubmitOptLoading extends AuthStates {}


class GoogleSingUpLoading extends AuthStates {}
class GoogleSingUpFailed extends AuthStates {
  final String error;

  GoogleSingUpFailed(this.error);
}

//Update User Info
class UserInfoUpdateLoading extends AuthStates {}
class UserInfoUpdateSuccess extends AuthStates {}
class UserInfoUpdateFailed extends AuthStates {
  final String error;

  UserInfoUpdateFailed(this.error);
}

//Pick Image
class ProfileImagePickedSuccessState extends AuthStates {}
class ProfileImagePickedFailedState extends AuthStates {}

class UserImageUpdateLoadingState extends AuthStates {}
class SocialUploadProfileImageFailedState extends AuthStates {}
class UploadProfileInFirebaseSuccessState extends AuthStates {}











