import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/styles_manager.dart';

class FilterWidget extends StatefulWidget {
  double marginVertical;
  double marginHorizental;
  void Function()? toggleMenu;
  FocusNode filterBtnNode;
  bool isFocused;

  FilterWidget(
      {required this.marginVertical,
      required this.marginHorizental,
      this.toggleMenu,
      required this.filterBtnNode,
      this.isFocused = false,
      Key? key})
      : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late int _selectedItemIndex;

  @override
  void initState() {
    _selectedItemIndex = -1;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: widget.filterBtnNode,
      onTap: widget.toggleMenu,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: MediaQuery.of(context).size.width * .13,
          height: MediaQuery.of(context).size.height * .1,
          margin: EdgeInsets.only(
            top: widget.marginVertical,
            right: widget.marginHorizental,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "FILTER",
                style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s18,
                    isUnderline: widget.isFocused),
              ),
              Icon(
                Icons.filter_list_rounded,
                color: ColorManager.white,
                size: FontSize.s40,
                shadows: widget.isFocused
                    ? [
                        BoxShadow(
                          color: ColorManager.white,
                          spreadRadius: 10,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
