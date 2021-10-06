import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterecom/data/models/product_rate_model.dart';
import 'package:flutterecom/shared/style/colors.dart';

class ReviewItem extends StatelessWidget {
 final ProductRateModel productRateItem;
 ReviewItem({Key? key, required this.productRateItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children:  [
              const CircleAvatar(
                backgroundColor: defaultColor,
                radius: 22.5,
                child: CircleAvatar(
                  radius: 23.0,
                  backgroundColor:Colors.white,
                  backgroundImage:NetworkImage('https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/iconbrand.png?alt=media&token=356fb615-a3b6-4f9d-8c09-741c1cc97b9e'),
                ),
              ),
              const SizedBox(width: 10.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productRateItem.name),
                  IgnorePointer(
                    ignoring: true,
                    child: RatingBar.builder(
                      initialRating: productRateItem.ratingValue.toDouble(),
                      direction: Axis.horizontal,
                      itemSize: 20.0,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        rating = rating;
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(productRateItem.commentTime,style: Theme.of(context).textTheme.caption,)
            ],
          ),
          productRateItem.comment!='' ? Column(
            children: [
              const SizedBox(height: 5.0,),
              Text(productRateItem.comment,style: const TextStyle(fontSize: 13.0,fontWeight: FontWeight.normal),),
            ],
          ) :Container(),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
    );
  }
}
