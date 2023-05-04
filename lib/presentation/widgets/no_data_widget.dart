import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iptv_sbi_v2/presentation/resources/styles_manager.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';

class NoDataWidget extends StatelessWidget {

  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No data",
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            /*TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "back",
                style: getSemiBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s12,
                    isUnderline: true),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
