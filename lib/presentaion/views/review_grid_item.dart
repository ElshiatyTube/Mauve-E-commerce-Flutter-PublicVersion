import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterecom/data/models/product_rate_model.dart';
import 'package:flutterecom/shared/style/colors.dart';

class ReviewGridItem extends StatelessWidget {
  final ProductRateModel productRateItem;
  ReviewGridItem({Key? key, required this.productRateItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children:  [
              const CircleAvatar(
                backgroundColor: defaultColor,
                radius: 22.5,
                child: CircleAvatar(
                  radius: 23.0,
                  backgroundColor:Colors.white,
                  backgroundImage:NetworkImage('https://firebasestorage.googleapis.com/v0/b/flutterecom-b7f81.appspot.com/o/usersImages%2Fimage_picker8390447758924593596.jpg?alt=media&token=815a264b-b4de-4ff1-b418-0a94dc5464cd'),
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
              Text(productRateItem.comment,style: const TextStyle(fontSize: 13.0,fontWeight: FontWeight.normal),maxLines: 3,overflow: TextOverflow.ellipsis,),
            ],
          ) :Container(),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
    );
  }
}
