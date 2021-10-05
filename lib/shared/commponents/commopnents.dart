import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';



Widget myDivider() =>
    Container(
      width: double.infinity,
      height: 0.5,
      color: Colors.grey[300],
    );

 showToast(
    {required String msg, required state, ToastGravity gravity = ToastGravity
        .BOTTOM}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastedStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastedStates states) {
  Color color;
  switch (states) {
    case ToastedStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastedStates.ERROR:
      color = Colors.red;
      break;
    case ToastedStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}



void navigateTo(context, widget) =>
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) => false,
    );

 Widget defaultLinearProgressIndicator()=>const LinearProgressIndicator(color: Colors.grey,);


enum ConnectionType{
  wifi,
  mobile,
}


Widget circularBoarderImage(image)=>Container(
  width: 100.0,
  height: 100.0,
  decoration: const BoxDecoration(
    image: DecorationImage(
        fit: BoxFit.cover, image: AssetImage('assets/images/caaar.jpg')),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

Widget animateListView({var buildItemClass, required int index}) {
  return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        child: FadeInAnimation(
            child: buildItemClass),
        verticalOffset: 50.0,
      ));
}

/*  Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              key: const PageStorageKey('keep'),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: cubit.categoryList.length,
              itemBuilder: (context, index) {
                return GridTile(
                  child: Center(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: 100.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: cubit.categoryList.elementAt(index).image,
                                fit: BoxFit.cover,
                                height: 50.0,
                                width: 50.0,
                                placeholder: (context, url) => Container(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ), //Image
                              const SizedBox(
                                height: 5.0,
                              ),
                              AutoSizeText(
                                cubit.categoryList.elementAt(index).name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),*/