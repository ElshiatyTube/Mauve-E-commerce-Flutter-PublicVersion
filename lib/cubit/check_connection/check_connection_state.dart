
import 'dart:io';

import 'package:flutterecom/shared/commponents/commopnents.dart';

abstract class CheckConnectionStates{}

class CheckConnectionLoading extends CheckConnectionStates {}

class InternetConnected extends CheckConnectionStates {

}
class InternetDisconnected extends CheckConnectionStates{}


