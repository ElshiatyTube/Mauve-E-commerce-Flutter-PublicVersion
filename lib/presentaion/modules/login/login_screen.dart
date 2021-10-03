import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/auth/auth_state.dart';
import 'package:flutterecom/presentaion/views/default_btn.dart';
import 'package:flutterecom/presentaion/views/default_form_field.dart';
import 'package:flutterecom/presentaion/views/default_txt_btn.dart';
import 'package:flutterecom/presentaion/views/elevated_btn_icon.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/images/images_svg.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:flutterecom/shared/validator.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneAuthFormKey = GlobalKey<FormState>();
  final phoneAuthController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    var cubit= AuthCubit.get(context);

    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginFailedState) {
          showToast(msg: 'error_wrong'.tr(), state: ToastedStates.ERROR);
        }
        if(state is ShopLoginPhoneCodeSuccessSend){
          Navigator.pushNamed(context, otpPath,arguments: state.phone);
        }
        if (state is LoginSuccessState) {

          CacheHelper.saveData(
            key: 'uId',
            value: state.userModel.uId,
          ).then((value) {
            AuthCubit.get(context).userModel = state.userModel;
            Navigator.pushNamedAndRemoveUntil(context,homeLayoutPath, (route) => false);
          });


        }
        if(state is LoginSuccessStateButNeedRegister){ //googleRegister
          Navigator.pushNamedAndRemoveUntil(
              context, registerPath, (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: [
              InkWell(
                onTap: () {
                  cubit.changeLang(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'lang'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            backgroundColor: Colors.black,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                children: [
                  Container(
                      color: Colors.black,
                      child: Image.asset(
                        'assets/images/lav.png',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height / 2.5,
                      )),
                  Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(17.0),
                          topRight: Radius.circular(17.0),
                        )),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'loginToEnjoy_txt'.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: Colors.black,
                                      ),
                                ),
                                InkWell(
                                    onTap: () {
                                     Navigator.pushNamedAndRemoveUntil(
                                         context, homeLayoutPath, (route) => false,);
                                    },
                                    child: Text(
                                      'Skip'.tr(),
                                      style:
                                          const TextStyle(color: defaultColor),
                                    )),
                              ],
                            ),
                           state is GoogleSingUpLoading ?  defaultLinearProgressIndicator(): Container(),
                            const SizedBox(
                              height: 10.0,
                            ),
                            DefaultFormField(
                              controller: emailController,
                              textInputType: TextInputType.emailAddress,
                              validator: Validator.validateEmail,
                              label: 'enter_email'.tr(),
                              prefixIcon: Iconly_Broken.Message,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            DefaultFormField(
                                controller: passController,
                                textInputType: TextInputType.visiblePassword,
                                isPassword: cubit.isPass,
                                onSubmit: (value) {
                                  if (formKey.currentState!.validate()) {
                                    cubit.uerLogin(
                                      email: emailController.text,
                                      password: passController.text,
                                    );
                                  }
                                },
                                validator: Validator.validatePassword,
                                label: 'password'.tr(),
                                prefixIcon: Iconly_Broken.Password,
                                suffixIcon: cubit.suffix,
                                suffixIconPressed: () {
                                  cubit.changePassVisibility();
                                }),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (BuildContext context) => DefaultButtonView(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.uerLogin(
                                        email: emailController.text,
                                        password: passController.text,
                                      );
                                    }
                                  },
                                  text: 'LOGIN_txt'.tr(),
                                  isUpperCase: true,
                                  radius: 5.0),
                              fallback: (BuildContext context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('dont_have_account'.tr()),
                                DefaultTextButtonView(
                                    textStyle: const TextStyle(fontSize: 15.0),
                                    text: 'register'.tr(),
                                    function: () {
                                      Navigator.pushNamed(context, registerPath,arguments: '');
                                    }),
                              ],
                            ),
                            Align(child: Text(' ـــــــــــــــ${'or_ling_by'.tr()}ـــــــــــــــ '),alignment: Alignment.center,),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButtonIconView(
                                    elevation: 0.5,
                                    bgColor: Colors.white,
                                      textColor: Colors.black,
                                      icon: const Icon(Iconly_Broken.Call,color: defaultColor,),
                                      text: 'sing_in_by_phone'.tr(),
                                      function: () => showBottomSheetForReviews(scaffoldKey,context,cubit)
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButtonIconView(
                                      elevation: 0.5,
                                      bgColor: Colors.white,
                                      textColor: Colors.black,
                                      text: 'google_sing_in'.tr(),
                                      function: () => _loginGoogle(context,cubit), icon: googleIcon,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showBottomSheetForReviews(GlobalKey<ScaffoldState> scaffoldKey,context,AuthCubit cubit) {

    scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height / 1.9,
        decoration: BoxDecoration(color: Color(0x00737373), borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration:  const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0))),
          child: Form(
            key: phoneAuthFormKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 60.0,
                      height: 2.5,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 12.0,
                  ),
                  DefaultFormField(
                    controller: phoneAuthController,
                    textInputType: TextInputType.phone,
                    hint: '01*********',
                    validator: (String? value) {
                      if (value!.isEmpty || value.length < 9) {
                        return 'enterPhoneVer'.tr();
                      }
                      return null;
                    },
                    label: 'enter_txt'.tr(),
                    prefixIcon: Iconly_Broken.Call,
                  ),
                  const SizedBox(height: 15.0,),
                  BlocBuilder<AuthCubit,AuthStates>(
                    builder: (context,state){
                      return ConditionalBuilder(
                        condition: state is! ShopLoginPhoneAuthLoading,
                        builder: (BuildContext context) {
                          return  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultButtonView(
                              radius: 10.0,
                              text: 'LOGIN_txt'.tr(),
                              function: () {
                                if (phoneAuthFormKey.currentState!.validate()) {
                                  print('LoginPressed ${'enter_sms'.tr()}');
                                  cubit.phoneAuth('+2${phoneAuthController.text}',context,'enter_sms'.tr());
                                }
                              },
                            ),
                          );
                        },
                        fallback:(context)=> const CircularProgressIndicator(),

                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _loginGoogle(context,cubit) {
    cubit.signInByGoogle();
  }

}
