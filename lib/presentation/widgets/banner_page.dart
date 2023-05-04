import 'package:flutter/material.dart';
import '../../data/env/env.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';

class BannerFB extends StatelessWidget {
  const BannerFB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .05, left: MediaQuery.of(context).size.width * .033,),
      width: MediaQuery.of(context).size.width * .35,
      height: MediaQuery.of(context).size.height * .15,
      decoration: BoxDecoration(
        color: ColorManager.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .04,
            height: MediaQuery.of(context).size.height * .1,
            child: Image.asset("${Environment.assetsPath}facebook_logo.png",),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("صفحة الفايسبوك الرسمية للسرفر", style: getSemiBoldStyle(color: ColorManager.white),),
              const SizedBox(height: 5,),
              Text("www.facebook.com/alphatv2", style: getSemiBoldStyle(color: ColorManager.white),),
              const SizedBox(height: 5,),

            ],
          )
        ],
      ),
    );
  }
}
