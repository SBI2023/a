import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/response/channel_response.dart';
import '../resources/color_manager.dart';
import '../resources/styles_manager.dart';

class InfoBarChannel extends StatefulWidget {
  ChannelModel? channelModel;

  InfoBarChannel({this.channelModel, Key? key}) : super(key: key);

  @override
  State<InfoBarChannel> createState() => _InfoBarChannelState();
}

class _InfoBarChannelState extends State<InfoBarChannel> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    DateTime dateNow = DateTime.now();
    String formattedDate = DateFormat.yMMMMEEEEd().format(dateNow);

    String timeNow = DateFormat.Hm().format(dateNow);

    print(formattedDate); // Output: vendredi, mars 10, 2023

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black87.withOpacity(0.75),
        ),
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .075,
          horizontal: MediaQuery.of(context).size.height * .15,
        ),
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * .2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              // margin: const EdgeInsets.only(left: 25),
              // padding: const EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width * .075,
              height: MediaQuery.of(context).size.height * .15,
              child: Image.network(widget.channelModel?.icon ?? ""),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              width: 2,
              height: MediaQuery.of(context).size.height * .2,
              color: ColorManager.white,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              height: MediaQuery.of(context).size.height * .12,
              child: Text(
                widget.channelModel?.name??"loading...",
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: 20,
                ),
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedDate,
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  timeNow,
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
