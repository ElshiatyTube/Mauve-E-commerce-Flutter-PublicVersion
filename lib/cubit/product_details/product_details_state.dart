abstract class ProductDetailsStates{}

class HomeLayoutInitState extends ProductDetailsStates {}

class IncreaseProductQuantityCounterState extends ProductDetailsStates{}
class DecreaseProductQuantityCounterState extends ProductDetailsStates{}

class emitRadioChangeState extends ProductDetailsStates{}
class emitFilterChangeState extends ProductDetailsStates{}

class DownloadProImageToShareLoadingState extends ProductDetailsStates{}
class DownloadProImageToShareSuccessState extends ProductDetailsStates{}


class emitChangeRatingValueState extends ProductDetailsStates{}

//Submit Rate
class SubmitUserProductRateLoadingState extends ProductDetailsStates{}
class SubmitUserProductRateSuccessState extends ProductDetailsStates{}
class SubmitUserProductRateErrorState extends ProductDetailsStates{
 final String error;

 SubmitUserProductRateErrorState(this.error);
}

//Get Rates
class ProductsRatesLoadingState extends ProductDetailsStates{}
class ProductsRatesSuccessState extends ProductDetailsStates{}


class ProductsRatesErrorState extends ProductDetailsStates{
 final String error;

 ProductsRatesErrorState(this.error);
}

//Get Suggested
class SuggestedProLoadingState extends ProductDetailsStates{}
class SuggestedProSuccessState extends ProductDetailsStates{}


class SuggestedProIsEmptyState extends ProductDetailsStates{}







