import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/auth/auth_state.dart';
import 'package:flutterecom/data/models/user_model.dart';
import 'package:flutterecom/presentaion/views/default_btn.dart';
import 'package:flutterecom/presentaion/views/default_form_field.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:flutterecom/shared/validator.dart';
import 'package:image_picker/image_picker.dart';

class UpdateAccountInfo extends StatefulWidget {
  final UserModel userModel;

  UpdateAccountInfo({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UpdateAccountInfo> createState() => _UpdateAccountInfoState();
}

class _UpdateAccountInfoState extends State<UpdateAccountInfo> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = AuthCubit.get(context).userModel.name;
    emailController.text = AuthCubit.get(context).userModel.email;
    phoneController.text = AuthCubit.get(context).userModel.phone;
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthStates>(
      listener: (BuildContext context, state) {
        if(state is UserInfoUpdateSuccess || state is UploadProfileInFirebaseSuccessState){
          Navigator.pop(context);
        }
        if(state is ProfileImagePickedSuccessState){
          AuthCubit.get(context).uploadProfileImage();
        }
      },
      builder: (context,state){
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state is UserImageUpdateLoadingState ? defaultLinearProgressIndicator() : Container(),
                  CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child:  Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: (){
                            AuthCubit.get(context).pickProfileImage();
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12.0,
                            child: Icon(
                              Iconly_Broken.Camera,
                              size: 18.0,
                              color: Color(0xFF404040),
                            ),
                          ),
                        ),
                      ),
                      radius: 55.0,
                      backgroundImage: AuthCubit.get(context).profileImage == null ? NetworkImage(
                        widget.userModel.image,
                      ) : FileImage(AuthCubit.get(context).profileImage!)  as ImageProvider,
                      /*backgroundImage: widget.userModel.image!='' ? NetworkImage(
                        widget.userModel.image
                    ) : const NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/camera.png?alt=media&token=fe74ab96-db87-497d-98db-602a851feacd'
                    ),*/
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
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
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    validator: Validator.validateEmail,
                    label: 'enter_email'.tr(),
                    prefixIcon: Iconly_Broken.Message,
                    isClickable: widget.userModel.emailBol ? false : true,
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
                    isClickable: widget.userModel.phoneBol ? false : true,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  BlocBuilder<AuthCubit,AuthStates>(
                    builder: (context,state){
                      return ConditionalBuilder(
                        condition: state is! UserInfoUpdateLoading,
                        builder: (BuildContext context) {
                          return Align(
                            alignment: Alignment.bottomRight,
                            child: DefaultButtonView(function: (){
                              if (formKey.currentState!.validate()){
                                AuthCubit.get(context).updateUserData(name: nameController.text, phone: phoneController.text, email: emailController.text);
                              }
                            }, text: 'Update',
                              radius: 15.0,
                              background: defaultColor,
                            ),
                          );
                        },
                        fallback: (BuildContext context) => defaultLinearProgressIndicator(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },

    );
  }

  Widget _loadingToUpdateImage() {
    return BlocBuilder<AuthCubit,AuthStates>(
        builder: (context,state){
          if(state is UserImageUpdateLoadingState){
            return defaultLinearProgressIndicator();
          }
          return Container();
        }
    );
  }
}
