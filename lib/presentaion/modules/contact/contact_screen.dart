import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterecom/cubit/auth/auth_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_state.dart';
import 'package:flutterecom/presentaion/views/default_btn.dart';
import 'package:flutterecom/presentaion/views/default_form_field.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/images/images_svg.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:flutterecom/shared/style/icon_broken.dart';
import 'package:flutterecom/shared/validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var phoneController = TextEditingController();

  var messageController = TextEditingController();

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(27.095534, 33.821923);
  final List<Marker> _customMarkers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = AuthCubit.get(context).userModel.name;
    phoneController.text = AuthCubit.get(context).userModel.phone;

    _customMarkers.add(const Marker(
        markerId: MarkerId('location'),
        position: LatLng(27.095534, 33.821923),
        infoWindow: InfoWindow(title: 'Our Location')));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    messageController.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const InputDecorationTheme defaultTheme = InputDecorationTheme();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Contact Us'),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close_outlined,
              color: MyColors.iconsColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultFormField(
                    controller: nameController,
                    textInputType: TextInputType.text,
                    validator: Validator.validateName,
                    label: 'Your Name',
                    prefixIcon: Iconly_Broken.User1,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DefaultFormField(
                    controller: phoneController,
                    textInputType: TextInputType.phone,
                    validator: Validator.validatePhone,
                    label: 'Phone',
                    prefixIcon: Iconly_Broken.Call,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 170.0,
                    child: TextFormField(
                      maxLines: 10,
                      keyboardType: TextInputType.text,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        filled: true,
                        fillColor: MyColors.iconsBgColor,
                        enabledBorder: defaultTheme.enabledBorder,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      validator: Validator.validateEmpty,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
                    listener: (context, state) {
                      if (state is UserSubmitContactMessageSuccessState) {
                        showToast(
                            msg: 'Your message have been send successfully',
                            state: ToastedStates.SUCCESS);
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      if (state is! UserSubmitContactMessageLoadingState) {
                        return DefaultButtonView(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              HomeLayoutCubit.get(context).submitUserMessage(
                                  uid: AuthCubit.get(context).userModel.uId,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  message: messageController.text);
                            }
                          },
                          background: defaultColor,
                          text: 'Send',
                          radius: 12.0,
                        );
                      }
                      return defaultLinearProgressIndicator();
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ExpansionTile(
                    tilePadding: const EdgeInsets.all(0.0),
                    title:  const Text('Hotlines',style: TextStyle(fontSize: 14.0),),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              HomeLayoutCubit.get(context).callNumber();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: MyColors.scaffoldBackgroundColorMain,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Iconly_Broken.Call,
                                          size: 18.0,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Hotline'.tr(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            color:
                                            Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      HomeLayoutCubit.get(context).hotline,
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          InkWell(
                            onTap: () {
                              HomeLayoutCubit.get(context).whatsappLaunch();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: MyColors.scaffoldBackgroundColorMain,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        whatsappIcon,
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                          'Whatsapp'.tr(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.normal,
                                            color:
                                            Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      HomeLayoutCubit.get(context).whatsapp,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text('You Can find Us',style: TextStyle(fontSize: 14.0),),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: MyColors.iconsBgColor,
                    ),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(_customMarkers),
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
