import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../choice_splash/view/choice_splash_view.dart';

class DisplayDialog extends StatefulWidget {
  BuildContext preContext;

  DisplayDialog({Key? key, required this.preContext}) : super(key: key);

  @override
  State<DisplayDialog> createState() => _DisplayDialogState();
}

class _DisplayDialogState extends State<DisplayDialog> {
  int _selectedButton = 0;
  final FocusNode _rawMainFocus = FocusNode();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _rawMainFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .017),
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .05,
              ),
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .2,
              // color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: ColorManager.selectedNavBarItem,
                  size: MediaQuery.of(context).size.height * .2,
                ),
              ),
            ),
            Text(
              'Do you want to exit ?',
              style: getRegularStyle(
                color: ColorManager.black,
                fontSize: MediaQuery.of(context).size.height * .07,
              ),
              textAlign: TextAlign.center,
            ),
            RawKeyboardListener(
              focusNode: _rawMainFocus,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                    if (_selectedButton == 0) {
                      setState(() {
                        _selectedButton = 1;
                      });
                    }
                  } else if (event.logicalKey ==
                      LogicalKeyboardKey.arrowLeft) {
                    if (_selectedButton == 1) {
                      setState(() {
                        _selectedButton = 0;
                      });
                    }
                  } else if (event.logicalKey == LogicalKeyboardKey.select) {
                    if (_selectedButton == 0) {
                      Get.offAll(() => const ChoiceScreenView());
                    } else {
                      Get.back();
                    }
                  }
                }
              },
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(
                        MediaQuery.of(context).size.height * .03,
                      ),
                      height: MediaQuery.of(context).size.height * .12,
                      child: OutlinedButton(
                        // focusNode: _okButtonFocus,
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Set the desired border radius value
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            _selectedButton == 0
                                ? ColorManager.selectedNavBarItem
                                : Colors.transparent,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                              width: 1,
                              color: ColorManager.selectedNavBarItem,
                            ),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(
                              150,
                              MediaQuery.of(context).size.height * .11,
                            ),
                          ),
                        ),
                        child: Text(
                          'OK',
                          style: getRegularStyle(
                            color: _selectedButton == 0
                                ? ColorManager.white
                                : ColorManager.selectedNavBarItem,
                            fontSize: MediaQuery.of(context).size.height * .075,
                          ),
                        ),
                        onPressed: () {
                          if (_selectedButton == 1) {
                            setState(() {
                              _selectedButton = 0;
                            });
                          } else {
                            Get.offAll(() => const ChoiceScreenView());
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(
                        MediaQuery.of(context).size.height * .03,
                      ),
                      height: MediaQuery.of(context).size.height * .12,
                      child: OutlinedButton(
                        // focusNode: _cancelButtonFocus,
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  4), // Set the desired border radius value
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            _selectedButton == 1
                                ? ColorManager.selectedNavBarItem
                                : Colors.transparent,
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(
                                width: 1,
                                color: ColorManager.selectedNavBarItem),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(
                              150,
                              MediaQuery.of(context).size.height * .11,
                            ),
                          ),
                        ),
                        child: Text(
                          'CANCEL',
                          style: getRegularStyle(
                            color: _selectedButton == 1
                                ? ColorManager.white
                                : ColorManager.selectedNavBarItem,
                            fontSize: MediaQuery.of(context).size.height * .075,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          if (_selectedButton == 0) {
                            setState(() {
                              _selectedButton = 1;
                            });
                          } else {
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
