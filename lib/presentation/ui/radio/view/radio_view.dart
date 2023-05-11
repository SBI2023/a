import 'package:flutter/material.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    BodyPage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/images';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: Color.fromARGB(255, 8, 31, 66),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Image.asset(
                "$imagePath/alpha_logo.png",
                height: 130,
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Radio',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 60,
                    height: 5,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(width: 28),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 43,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 8, 31, 66),
        child: Center(
          child: _children[_currentIndex],
        ),
      ),
    );
  }
}

class BodyPage extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  int selectedIndex = 0;

  final List<String> menuItems = ['Radio.', 'Radio Genre'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 8, 31, 66),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: menuItems
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.all(2.2),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = entry.key;
                            });
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 40.0,
                              color: selectedIndex == entry.key
                                  ? Colors.white
                                  : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 38.0,
                                ),
                                child: Stack(
                                  children: [
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 18,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 2.5
                                          ..color = Colors.black,
                                      ),
                                    ),
                                    Text(
                                      entry.value,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              width: 580,
              color: Color.fromARGB(255, 8, 31, 66),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Search Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
