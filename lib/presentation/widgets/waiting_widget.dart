import 'package:flutter/material.dart';

import '../resources/color_manager.dart';

class WaitingWidget extends StatelessWidget {
  String title;
  WaitingWidget({required this.title,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: ColorManager.darkPrimary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              color: ColorManager.white,
            ),
          ],
        ),
      ),
    );
  }
}
