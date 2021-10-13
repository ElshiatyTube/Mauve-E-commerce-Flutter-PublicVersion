abstract class UserAddressState{}
class UserAddressInitState extends UserAddressState {}


//Address States
class RemoveAddressItemLoadingState extends UserAddressState {}
class RemoveAddressItemSuccessState extends UserAddressState {}
class RemoveAddressItemFailedState extends UserAddressState {
  final String error;

  RemoveAddressItemFailedState(this.error);
}
class PickedPlaceSuccess extends UserAddressState {
  final double lat,lng;
  final String formattedAddress;

  PickedPlaceSuccess({required this.lat, required this.lng,required this.formattedAddress,});
}

class UpdateAddressLocLoadingState extends UserAddressState {}
class UpdateAddressTextSuccessState extends UserAddressState {}
class UpdateAddressTextFailedState extends UserAddressState {
  final String error;

  UpdateAddressTextFailedState(this.error);
}






