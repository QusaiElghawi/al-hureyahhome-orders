import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes.dart';


class SvgImage extends StatelessWidget {
  const SvgImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 110),
                child: SvgPicture.asset(
                  'assets/images/task.svg',
                  height: 90,
                  color: primaryClr.withOpacity(0.5),

                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'You do not have any Order',
                style: Themes().subTitleHeadingStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }
}
