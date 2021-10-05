import 'package:flutter/cupertino.dart';

late BuildContext mainAppContext;

const String splashPath = '/';
const String loginPath = '/login';
const String registerPath = '/register';
const String homeLayoutPath = '/home_layout';
const String productDetailsPath = '/product_details';
const String otpPath = '/otp';



//final navigatorKey = GlobalKey<NavigatorState>();



final String USER_COLLECTION ='Users';
final String TOKEN_COLLECTION ='Tokens';

final String OFFERS_COLLECTION ='Offers';
final String OFFERS_OFFERLIST_COLLECTION ='offerList';



final String CATEGORIES_COLLECTION ='Categories';
final String PRODUCTS_COLLECTION ='products';
final String RATES_COLLECTION ='rates';
final String ORDERS_COLLECTION ='Orders';
final String SHIPPER_ORDERS_COLLECTION ='ShippingOrder';
final String INFO_COLLECTION ='Info';
final String PROMOS_COLLECTION ='Promos';
final String INVITAIONSCODES_COLLECTION ='InvitationsCodes';



/*
Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
//  _checkInternetConnectionListener(),
authCubit.userModel.uId != ''
? Text('Hello ${authCubit.userModel.name} in Home Layout')
: const Text('Hello Anon in HOme Layout'),
ElevatedButton(
onPressed: () {
AuthCubit.get(context).signOut(context);
},
child: Text('LogOut'.tr())),
ElevatedButton(
onPressed: () {
EasyLocalization.of(context)!
    .setLocale(const Locale('ar', 'AR'))
    .then((_) {
// Phoenix.rebirth(context);
OneNotification.hardReloadRoot(context);
});
},
child: const Text('Arabic')),
ElevatedButton(
onPressed: () {
EasyLocalization.of(context)!
    .setLocale(const Locale('en', 'EN'))
    .then((_) {
// Phoenix.rebirth(context);
OneNotification.hardReloadRoot(context);
});
},
child: const Text('English')),
ElevatedButton(
onPressed: () {
Navigator.pushNamedAndRemoveUntil(
context, loginPath, (route) => false);
},
child: const Text('login')),
],
),
)*/
