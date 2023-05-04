import 'package:flutter/material.dart';

import '../../../resources/color_manager.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  FocusNode searchFocusNode;

  SearchBar({super.key, required this.controller, required this.searchFocusNode});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _selectedType = 'Type 1';
  final List<String> _types = ['Type 1', 'Type 2', 'Type 3'];
  bool _isContainerVisible = false;
  bool _isTypesTextVisible = false;

  void _showDropDown() {
    setState(() {
      _isContainerVisible = !_isContainerVisible;
    });
  }

  void _showTypes() {
    setState(() {
      _isTypesTextVisible = !_isTypesTextVisible;
      // if (_isContainerVisible) {
      //   _isTypesTextVisible = true;
      // } else {
      //   _isTypesTextVisible = false;
      // }
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _isContainerVisible = false;
  //   _isTypesTextVisible = true;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // color: ColorManager.lightBlue,
                width: MediaQuery.of(context).size.width * .7,
                height: MediaQuery.of(context).size.height * .15,
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .05,
                    top: MediaQuery.of(context).size.height * .1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0, 0.6],
                    colors: ColorManager.searchBarColor,
                  ),
                  border: Border.all(color: ColorManager.lightBlue, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _isContainerVisible ? _isTypesTextVisible = false : _showTypes();
                        _showDropDown();
                      },
                      child: Container(
                        // color: ColorManager.darkPrimary,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * .15,
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * .012),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorManager.mediumDarkPrimary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "CHANNEL",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: ColorManager.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.searchFocusNode,
                        textDirection: TextDirection.ltr,
                        style: Theme.of(context).textTheme.labelMedium,
                        cursorColor: ColorManager.white,
                        decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          // enabled: false,
                          hintText: 'Tap to search..',
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .08,
                height: MediaQuery.of(context).size.height * .15,
                child: OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      ColorManager.lightPrimary,
                    ),
                    side: const MaterialStatePropertyAll(
                      BorderSide(style: BorderStyle.none),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.search,
                    color: ColorManager.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(
        //   height: 20,
        // ),
        Align(
          alignment: Alignment.topLeft,
          child: AnimatedContainer(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * .05,
              top: MediaQuery.of(context).size.height * .03,
            ),
            onEnd: () => _showTypes(),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: _isContainerVisible
                ? MediaQuery.of(context).size.height * .3
                : 0,
            width: MediaQuery.of(context).size.width * .15,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .012),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorManager.mediumDarkPrimary,
              border: Border.all(color: ColorManager.lightPrimary, width: 2),
            ),
            child: _isTypesTextVisible
                ? Column(
                    children: const [
                      Text("type 1"),
                      Text("type 2"),
                      Text("type 3"),
                    ],
                  )
                : Container(),
          ),
        ),
      ],
    );

    /*Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Dropdown button for selecting type of search
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton(
              value: _selectedType,
              items: _types.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
          ),
          // Search text field
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          // Search button
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );*/
  }
}
