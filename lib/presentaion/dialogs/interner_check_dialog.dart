import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class NoInternetDialog extends StatelessWidget {
  final bool canDismiss;
  const NoInternetDialog({Key? key,this.canDismiss = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {  return canDismiss ? true : false; },
      child: AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.not_interested),
            Expanded(child: Text('not_net_title'.tr(),style: Theme.of(context).textTheme.bodyText1,))
          ],
        ),
        content: Text('not_net_msg'.tr(),style: Theme.of(context).textTheme.caption,),
      ),
    );
  }
}
