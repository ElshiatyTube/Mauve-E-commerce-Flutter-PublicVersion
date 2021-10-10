import 'package:bloc/bloc.dart';

abstract class CartStates{}

class CartInitState extends CartStates {}


class TestCartState extends CartStates {}

class AddToCartSuccessState extends CartStates {}
class AddToCartErrorState extends CartStates {
  final String error;

  AddToCartErrorState(this.error);
}
class DeleteProductFromCartState extends CartStates {}
class ClearAllCartItemsState extends CartStates {}



