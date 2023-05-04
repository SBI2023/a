import 'dart:async';
import 'package:flutter/material.dart';

class BackgroundSlider extends StatefulWidget {
  final List<String> images;

  const BackgroundSlider({Key? key, required this.images}) : super(key: key);

  @override
  _BackgroundSliderState createState() => _BackgroundSliderState();
}

class _BackgroundSliderState extends State<BackgroundSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (_currentPage < widget.images.length - 1) {
        _controller.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _controller.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: widget.images
            .map((image) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ))
            .toList(),
      ),
    );
  }
}
