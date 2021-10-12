import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/auth/auth_state.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_state.dart';
import 'package:flutterecom/presentaion/dialogs/update_account_info_dialog.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/images/images_svg.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:one_context/one_context.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeLayoutCubit.get(context).getWelcomeText(DateTime.now());
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeLayoutCubit, HomeLayoutStates>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //About,chat,contact
                    children: [
                      _userInfoCard(),
                      const SizedBox(height: 12.0,),
                      _aboutAndContactAndChatCard(),
                      const SizedBox(height: 12.0,),
                      _languagesCar(),

                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child:  InkWell(
                  child: const Text('Sign out',style: TextStyle(color: defaultColor),),
                  onTap: (){
                      AuthCubit.get(context).signOut(context);
                  },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _userInfoCard()=>ConditionalBuilder(
    condition: AuthCubit.get(context).userModel.uId !='',
    builder: (context){

      return BlocBuilder<AuthCubit,AuthStates>(
       builder: (context,state){
         return  Container(
           padding: const EdgeInsets.all(12.0),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(10.0),
             color: Colors.white,
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   ClipRRect(
                     child: CachedNetworkImage(
                       fit: BoxFit.cover,
                       imageUrl: AuthCubit.get(context).userModel.image,
                       height: 75.0,
                       width: 75.0,
                     ),
                     borderRadius: BorderRadius.circular(8.0),
                   ),
                   const SizedBox(width: 10.0,),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('${HomeLayoutCubit.get(context).welcomeText}, ${AuthCubit.get(context).userModel.name}',maxLines: 2,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 15.0),),
                         const SizedBox(height: 4.0,),
                         AuthCubit.get(context).userModel.email != '' ?  Text(AuthCubit.get(context).userModel.email,style: Theme.of(context).textTheme.caption,maxLines: 1,overflow: TextOverflow.ellipsis,) : Container(),
                         const SizedBox(height: 2.0,),
                         Text(AuthCubit.get(context).userModel.phone,style: Theme.of(context).textTheme.caption,maxLines: 1,overflow: TextOverflow.ellipsis,),

                       ],
                     ),
                   ),
                   InkWell(child: Container(
                       padding: const EdgeInsets.all(5.0),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5.0),
                       color: MyColors.iconsBgColor,
                     ),
                       child: const Icon(Iconly_Broken.Edit,color: defaultColor,)
                   ),onTap: (){
                     showDialog(
                         barrierDismissible: true,
                         context: context,
                         builder: (BuildContext context){
                           return Dialog(
                             insetPadding: const EdgeInsets.all(15),
                             shape: const RoundedRectangleBorder(
                                 borderRadius:
                                 BorderRadius.all(
                                     Radius.circular(10.0))),
                             child: UpdateAccountInfo(userModel: AuthCubit.get(context).userModel),
                           );
                         }
                     );
                   },),
                 ],
               ),
               const SizedBox(height: 25.0,),
               InkWell(
                 onTap: (){
                   Navigator.pushNamed(context, userAddressPath);
                 },
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container(
                       child:const Icon(Iconly_Broken.Location,color: MyColors.iconsColor,),decoration:BoxDecoration(
                       color: MyColors.iconsBgColor,
                       borderRadius:  BorderRadius.circular(5.0),
                     ),padding: const EdgeInsets.all(5.0),
                     ),
                     const SizedBox(width: 5.0,),
                     const Text('My Address'),
                     const Spacer(),
                     const Icon(Icons.keyboard_arrow_right,color: Colors.black54,),
                   ],
                 ),
               ),
             ],
           ),
         );
       },
      );
    },
    fallback: (_)=>Container(),
  );

  Widget _aboutAndContactAndChatCard() => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.white,
    ),
    child: Column(
      children: [
        ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child:const Icon(Iconly_Broken.User1,color: MyColors.iconsColor,),decoration:BoxDecoration(
                color: MyColors.iconsBgColor,
                borderRadius:  BorderRadius.circular(5.0),
              ),padding: const EdgeInsets.all(5.0),
              ),
              const SizedBox(width: 5.0,),
              const Text('About Us'),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(
                10.0,
              ),
              child: Text(
                context.locale.toString() == 'en_EN'? HomeLayoutCubit.get(context).about : HomeLayoutCubit.get(context).aboutAr,
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child:const Icon(Iconly_Broken.Calling,color: MyColors.iconsColor,),decoration:BoxDecoration(
                color: MyColors.iconsBgColor,
                borderRadius:  BorderRadius.circular(5.0),
              ),padding: const EdgeInsets.all(5.0),
              ),
              const SizedBox(width: 5.0,),
              const Text('Contact Us'),
            ],
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    HomeLayoutCubit.get(context).callNumber();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: MyColors.scaffoldBackgroundColorMain,
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconly_Broken.Call,size: 18.0,color: Colors.red,),
                              const SizedBox(width: 5.0,),
                              Text(
                                'Hotline'.tr(),
                                style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.6),),
                              ),
                            ],
                          ),
                          Text(
                            HomeLayoutCubit.get(context).hotline,
                            style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.6),),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15.0,),
                InkWell(
                  onTap: (){
                    HomeLayoutCubit.get(context).whatsappLaunch();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: MyColors.scaffoldBackgroundColorMain,
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              whatsappIcon,
                              const SizedBox(width: 5.0,),
                              Text(
                                'Whatsapp'.tr(),
                                style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.6),),
                              ),
                            ],
                          ),
                          Text(
                            HomeLayoutCubit.get(context).whatsapp,
                            style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.6),),
                          )

                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 15.0,),
          ],
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, chatPath);
          },
          child: Padding(
            padding: const EdgeInsets.all(
              15.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child:const Icon(Iconly_Broken.Chat,color: MyColors.iconsColor,),decoration:BoxDecoration(
                  color: MyColors.iconsBgColor,
                  borderRadius:  BorderRadius.circular(5.0),
                ),padding: const EdgeInsets.all(5.0),
                ),
                const SizedBox(width: 5.0,),
                const Text('RealTime Chat'),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _languagesCar() => InkWell(
    onTap: (){
      EasyLocalization.of(context)!.setLocale( context.locale.toString() == 'en_EN' ? const Locale('ar', 'AR') : const Locale('en', 'EN')).then((_) {
      //  OneNotification.hardReloadRoot(context);
      });
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child:const Icon(Icons.language,color: MyColors.iconsColor,),decoration:BoxDecoration(
              color: MyColors.iconsBgColor,
              borderRadius:  BorderRadius.circular(5.0),
            ),padding: const EdgeInsets.all(5.0),
            ),
            const SizedBox(width: 5.0,),
            const Text('Languages'),
            const Spacer(),
            context.locale.toString() == 'en_EN' ?  Text('Arabic',style: Theme.of(context).textTheme.caption,) : Text('English',style: Theme.of(context).textTheme.caption,),
            const Icon(Icons.keyboard_arrow_right,color: Colors.black54,),

          ],
        ),
      ),
    ),
  );

}
