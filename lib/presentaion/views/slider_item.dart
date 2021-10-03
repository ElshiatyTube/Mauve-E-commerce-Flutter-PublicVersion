
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/cubit/home_layout/home_layout_cubit.dart';
import 'package:flutterecom/presentaion/layouts/home_layout.dart';
import 'package:flutterecom/presentaion/modules/home/home_screen.dart';
import 'package:flutterecom/shared/style/colors.dart';
import 'package:easy_localization/easy_localization.dart';

class SliderItem extends StatelessWidget {
  final OfferMode offerItem;
  final List<OfferMode> offers;

  const SliderItem({Key? key, required this.offerItem, required this.offers}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: 300,
              imageUrl: offerItem.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(
              0.4,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Text(
            context.locale.toString() == 'en_EN'
                ? offerItem.title
                : offerItem.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
          ),
        ),
        Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: offers.map(
                  (image) {
                //these two lines
                int index =
                offers.indexOf(image); //are changed
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HomeLayoutCubit.get(context).currentIndicator == index
                          ? defaultColor
                          : Colors.white),
                );
              },
            ).toList(),
          ),
          alignment: Alignment.bottomCenter,
        ),
      ],
    );
  }
}
