import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/auth/auth_state.dart';
import 'package:flutterecom/presentaion/views/default_btn.dart';
import 'package:flutterecom/presentaion/views/default_form_field.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:flutterecom/shared/validator.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    phoneController.text = cubit.phoneLoginPhoneNum;
    emailController.text = cubit.googleLLoginEmail;

    print('email: ${cubit.googleLLoginEmail} phone: ${cubit.phoneLoginPhoneNum}');

    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is CreateUserSuccessState) {

          CacheHelper.saveData(
            key: 'uId',
            value: state.userModel.uId,
          ).then((value) {
            AuthCubit.get(context).userModel = state.userModel;
            Navigator.pushNamedAndRemoveUntil(
              context, homeLayoutPath, (route) => false);
          });

        }
        if (state is CreateUserFailedState) {
          showToast(msg: 'error_wrong'.tr(), state: ToastedStates.ERROR);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'register'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                'registerToEnjoy_txt'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      DefaultFormField(
                        controller: nameController,
                        textInputType: TextInputType.name,
                        validator: Validator.validateName,
                        label: 'enter_name'.tr(),
                        prefixIcon: Iconly_Broken.User,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      DefaultFormField(
                        controller: addressController,
                        textInputType: TextInputType.text,
                        validator: Validator.validateAddress,
                        label: 'enter_address'.tr(),
                        prefixIcon: Iconly_Broken.Location,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      DefaultFormField(
                        controller: phoneController,
                        textInputType: TextInputType.phone,
                        validator: Validator.validatePhone,
                        label: 'enter_phone'.tr(),
                        prefixIcon: Iconly_Broken.Call,
                        isClickable:
                            cubit.phoneLoginPhoneNum == '' ? true : false,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      DefaultFormField(
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                        validator: cubit.phoneLoginPhoneNum == ''
                            ? Validator.validateEmail
                            : Validator.validateEmailCorrect,
                        label: cubit.phoneLoginPhoneNum == ''
                            ? 'enter_email'.tr()
                            : 'enter_email_optional'.tr(),
                        prefixIcon: Iconly_Broken.Message,
                        isClickable: cubit.googleLLoginEmail == '' ? true : false,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      (cubit.phoneLoginPhoneNum == '' && cubit.googleLLoginEmail == '')
                          ? DefaultFormField(
                              controller: passController,
                              textInputType: TextInputType.visiblePassword,
                              isPassword: AuthCubit.get(context).isPass,
                              onSubmit: (value) {},
                              validator: Validator.validatePassword,
                              label: 'password'.tr(),
                              prefixIcon: Iconly_Broken.Password,
                              suffixIcon: AuthCubit.get(context).suffix,
                              suffixIconPressed: () {
                                AuthCubit.get(context).changePassVisibility();
                              })
                          : Container(),
                      const SizedBox(
                        height: 28.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (BuildContext context) => DefaultButtonView(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                if (cubit.phoneLoginPhoneNum == '' && cubit.googleLLoginEmail == '') {
                                  //normalRegister
                                  AuthCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passController.text,
                                    name: nameController.text,
                                    address: addressController.text,
                                    phone: phoneController.text,
                                  );
                                } else {
                                  //phone or google Register
                                  AuthCubit.get(context).userCreate(
                                    email: emailController.text,
                                    name: nameController.text,
                                    address: addressController.text,
                                    phone: phoneController.text,
                                    uId: cubit.phoneOrEmailUid,
                                  );
                                }
                              }
                            },
                            text: 'register'.tr(),
                            isUpperCase: true,
                            radius: 5.0),
                        fallback: (BuildContext context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
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
