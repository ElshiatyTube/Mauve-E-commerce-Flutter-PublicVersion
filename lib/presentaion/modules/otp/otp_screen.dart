import 'dart:math';

import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/auth/auth_state.dart';
import 'package:flutterecom/presentaion/modules/register/register_screen.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  late String otpCode;

  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'verity_phone_txt'.tr(),
          style: const TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
              text: 'enter_code_txt'.tr(),
              style: const TextStyle(
                  color: Colors.black, fontSize: 18, height: 1.4),
              children: <TextSpan>[
                TextSpan(
                  text: phoneNumber,
                  style: const TextStyle(color: defaultColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinCodeFields(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      autoFocus: true,
      cursorColor: Colors.black,
      textStyle: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        borderWidth: 1,
        activeColor: defaultColor,
        inactiveColor: defaultColor,
        inactiveFillColor: Colors.white,
        activeFillColor: defaultColor,
        selectedColor: defaultColor,
        selectedFillColor: Colors.white,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      enableActiveFill: true,
      onCompleted: (submitedCode) {
        otpCode = submitedCode;
        print("Completed");
        _verify(context);
      },
      onChanged: (value) {
        print(value);
      },
    );
  }

  void _verify(BuildContext context) {
    AuthCubit.get(context).submitOTP(otpCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is ShopLoginLoadingDoneTypeOTB){
          AuthCubit.get(context).checkUserExistInDatabase(uid: state.uId,phone: state.phone, email: state.email);
        }
      },
      builder: (context,state){
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 88),
                  child: Column(
                    children: [
                     state is  SubmitOptLoading ?  defaultLinearProgressIndicator() :  Container(),
                      _buildIntroTexts(),
                      const SizedBox(
                        height: 88,
                      ),
                      _buildPinCodeFields(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }
}
