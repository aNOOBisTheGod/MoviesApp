import 'package:flutter/material.dart';
import '../widgets/filters.dart';
import '../widgets/filmcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import 'introduction.dart';
import 'dart:math';

class DrawClip extends CustomClipper<Path> {
  double move = 0;
  double slice = pi;
  DrawClip(this.move);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * sin(move * slice);
    double yCenter = size.height * 0.8 + 69 * cos(move * slice);
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  bool _buttonLoading = false;
  List? films;
  bool _isLoading = true;
  int _currentPage = 1;

  AnimationController? _controller;

  @override
  void initState() {
    getData();
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: Duration(seconds: 25),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isFirstTime = sharedPreferences.getBool('firsttime') ?? true;
    print(isFirstTime);
    if (isFirstTime) {
      Navigator.of(context).pushNamed(IntoduceScreen.routeName);
    }
    films = await getPopular(1);
    setState(() {
      print('loading done');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller!,
                builder: (BuildContext context, child) {
                  return ClipPath(
                    clipper: DrawClip(_controller!.value),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors:
                                Theme.of(context).brightness == Brightness.dark
                                    ? [Color(0xFFE0647B), Color(0xFFFCDD89)]
                                    : [Color(0xFFd25ce6), Color(0xFFf90047)]),
                      ),
                    ),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(bottom: 60),
                child: Text(
                  'WhatToWatch',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Find your movie!',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Select genres',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              IconButton(
                  onPressed: () {
                    // showModalBottomSheet(
                    //   barrierColor: Colors.black.withAlpha(1),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   context: context,
                    //   builder: (_) => MyBottomSheet(),
                    // ).then((value) => getData());
                    showModalBottomSheet(
                            context: context,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            builder: (context) => MyBottomSheet())
                        .then((value) => getData());
                  },
                  icon: Icon(Icons.settings_suggest_outlined))
            ],
          ),
          // ElevatedButton(
          //     onPressed: () => rateMovie(200, 8), child: Text('test')),
          if (_isLoading)
            Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          else ...[
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 5 / 6,
                crossAxisCount: MediaQuery.of(context).size.width ~/ 300,
              ),
              padding: EdgeInsets.only(right: 30, left: 30),
              itemCount: films!.length,
              itemBuilder: (context, index) {
                return FilmCard(films![index]);
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: AnimatedSwitcher(
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      child: child,
                      opacity: animation,
                    );
                  },
                  duration: Duration(milliseconds: 200),
                  child: !_buttonLoading
                      ? TextButton(
                          key: ValueKey(_buttonLoading),
                          onPressed: () async {
                            _currentPage += 1;
                            setState(() {
                              _buttonLoading = true;
                            });
                            List temp = await getPopular(_currentPage);
                            setState(() {
                              _buttonLoading = false;
                              films!..addAll(temp);
                            });
                          },
                          child: Text(
                            'View more!',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))
                      : CircularProgressIndicator(
                          key: ValueKey(_buttonLoading),
                          color: Theme.of(context).primaryColor,
                        ),
                ))
          ]
        ],
      ),
    );
  }
}
