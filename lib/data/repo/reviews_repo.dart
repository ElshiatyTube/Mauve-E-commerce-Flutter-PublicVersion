import 'package:flutterecom/data/api/reviews_api.dart';
import 'package:flutterecom/data/models/product_rate_model.dart';

class ReviewsRepo{
  final ReviewsApi reviewsApi;

  ReviewsRepo(this.reviewsApi);

  Future<List<ProductRateModel>> getReviews() async{
    final reviews = await reviewsApi.getReviews();
    return reviews.toList();
  }
  Future<List<ProductRateModel>> getReviewsNonLimited() async{
    final reviews = await reviewsApi.getReviewNonLimited();
    return reviews.toList();
  }
}