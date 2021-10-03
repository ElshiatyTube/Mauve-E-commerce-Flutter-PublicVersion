import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/data/models/boarding_model.dart';
import 'package:flutterecom/presentaion/views/boarder_item.dart';
import 'package:flutterecom/presentaion/views/default_txt_btn.dart';
import 'package:flutterecom/shared/commponents/commopnents.dart';
import 'package:flutterecom/shared/constants/constants.dart';
import 'package:flutterecom/shared/images/images_svg.dart';
import 'package:flutterecom/shared/network/local/cache_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutterecom/shared/route/routes.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  var boardController = PageController();
  bool isLast = false;


  List<BoardingModel> boardingList = [
    BoardingModel(onBoard1Svg,
        'onBoardBody1','onBoardTitle1'),
    BoardingModel(onBoard2Svg,
        'onBoardBody2','onBoardTitle2'),
    BoardingModel(onBoard3Svg,
        'onBoardBody3','onBoardTitle3'),
  ];

  void submit() {
    CacheHelper.saveData(key: 'onboard', value: true).then((value) {
      if (value) {
       Navigator.pushNamedAndRemoveUntil(context, loginPath, (route) => false);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [

            context.locale.toString().contains('en')?DefaultTextButtonView(
              text: 'عربي',
              function: ()
              {
                EasyLocalization.of(context)!.setLocale(const Locale('ar', 'AR'));
              },
            ):
            DefaultTextButtonView(
              text: 'English',
              function: ()
              {
                EasyLocalization.of(context)!.setLocale(const Locale('en', 'EN'));
              },
            ),

          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: boardController,
                  itemBuilder: (context, index) =>
                      BuildBoarderItem(boardingModel: boardingList[index], ),
                  itemCount: boardingList.length,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int index) {
                    if (index == boardingList.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                    controller: boardController,
                    count: boardingList.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: defaultColor,
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5.0,
                    ),
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        boardController.nextPage(
                          duration: const Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }
                    },
                    child:isLast? Text('Start'.tr(),style: TextStyle(color: Colors.white),) : const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}
