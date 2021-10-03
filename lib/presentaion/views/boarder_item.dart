import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutterecom/data/models/boarding_model.dart';
import 'package:flutterecom/shared/style/colors.dart';

class BuildBoarderItem extends StatelessWidget {
  final BoardingModel boardingModel;

  const BuildBoarderItem({Key? key,required this.boardingModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: boardingModel.image),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          boardingModel.title.tr(),
          style: const TextStyle(
            fontSize: 20.0,
            color: defaultColor,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          boardingModel.body.tr(),
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
