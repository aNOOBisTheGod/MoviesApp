import 'package:flutter/material.dart';
import 'package:movies/functions.dart';
import '../themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:async';

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

// class ScrollClip extends CustomClipper<Path> {
//   double move = 0;
//   double slice = pi;
//   ScrollClip(this.move);
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(size.width, 0);
//     double xCenter =
//         size.width * 0.5 + (size.width * 0.6 + 1) * sin(move * slice);
//     double yCenter = size.height * 0.8 + 69 * cos(move * slice);
//     path.quadraticBezierTo(xCenter, yCenter, size.width, size.height);
//     path.quadraticBezierTo(xCenter, yCenter, size.width, size.height);

//     path.lineTo(size.width, 0);
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }

class IntoduceScreen extends StatefulWidget {
  static const routeName = '/introduce';

  @override
  _IntoduceScreenState createState() => _IntoduceScreenState();
}

class _IntoduceScreenState extends State<IntoduceScreen>
    with TickerProviderStateMixin {
  Timer? timer;
  AnimationController? _controller;
  AnimationController? _scrollController;
  int _currentStep = 0;
  bool _updated = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0.0,
      duration: Duration(seconds: 25),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
    _scrollController = AnimationController(
      value: 0.2,
      duration: Duration(seconds: 1),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  static const List<Map> assets = [
    {
      'image': 'assets/images/image.jpg',
      'text':
          'Application uses moviesAPI that will help you to find really good movies just in a second(swipe to move slides).',
    },
    {
      'image': 'assets/images/movie.jpg',
      'text':
          'You can filter movies by genre and query(in the future) if you want to.',
    },
    {
      'image': 'assets/images/overview.jpg',
      'text':
          'Only approved overviews. You don\'t have to filter them as usual. Also if there is no overviews, we will give you a link to website with them.',
    },
    {
      'image': 'assets/images/development.jpg',
      'text':
          'Now application is in development stage, so there will be a lot of new features! Also there will be good if You will leave feedback about application on GitHub',
    }
  ];
  @override
  Widget build(BuildContext context) {
    _scrollController!.value = 0.5;
    return Theme(
      data: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? dark
          : light,
      child: Scaffold(
        floatingActionButton: _currentStep == assets.length - 1
            ? FloatingActionButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setBool('firsttime', false);
                },
                tooltip: 'Let\'s Start!',
                child: Icon(Icons.arrow_forward_ios),
              )
            : null,
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            // Timer.periodic(const Duration(milliseconds: 5), (timer) {
            //   _scrollController!.value += 0.01;
            //   if (_scrollController!.value >= 0.5) {
            //     _scrollController!.value = 0.5;
            //     timer.cancel();
            //   }
            // });
            int sensitivity = 10;
            if (details.primaryVelocity! > sensitivity && _currentStep != 0) {
              _updated = true;
              setState(() {
                _currentStep--;
              });
            } else if (details.primaryVelocity! < -sensitivity &&
                _currentStep != assets.length - 1) {
              setState(() {
                _currentStep++;
              });
            }
          },
          onHorizontalDragUpdate: (details) {
            if (_scrollController!.value == 0.5 && details.delta.dx >= 0) {
              return;
            }
            _scrollController!.value = 0.5 *
                details.globalPosition.dx /
                MediaQuery.of(context).size.width;
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
            ),
            child: Stack(
              children: [
                Column(children: [
                  AnimatedBuilder(
                    animation: _controller!,
                    builder: (BuildContext context, child) {
                      return ClipPath(
                        clipper: DrawClip(_controller!.value),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text(
                            'What To Watch',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? [Color(0xFFE0647B), Color(0xFFFCDD89)]
                                    : [Color(0xFFd25ce6), Color(0xFFf90047)]),
                          ),
                        ),
                      );
                    },
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       _scrollController?.value = -_scrollController!.value;
                  //     },
                  //     child: Text('123')),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: Image.asset(
                          assets[_currentStep]['image'],
                          height: MediaQuery.of(context).size.height * 0.4,
                          key: ValueKey<int>(_currentStep),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            child: child,
                            opacity: animation,
                          );
                        },
                        child: Text(
                          assets[_currentStep]['text'],
                          key: ValueKey<int>(_currentStep),
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  // MediaQuery.of(context).orientation != Orientation.portrait
                  //     ? Padding(
                  //         padding: EdgeInsets.only(
                  //             top: MediaQuery.of(context).size.height * 0.7,
                  //             left: MediaQuery.of(context).size.width * 0.4),
                  //         child: ElevatedButton(
                  //             style: ButtonStyle(
                  //                 maximumSize: MaterialStateProperty.all<Size>(
                  //                     Size(100, 100)),
                  //                 backgroundColor:
                  //                     MaterialStateProperty.all<Color>(
                  //                         Theme.of(context).primaryColor)),
                  //             onPressed: () {
                  //               setState(() {
                  //                 if (_currentStep != assets.length - 1)
                  //                   _currentStep += 1;
                  //               });
                  //             },
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 FaIcon(FontAwesomeIcons.chevronRight),
                  //                 FaIcon(FontAwesomeIcons.chevronRight),
                  //                 FaIcon(FontAwesomeIcons.chevronRight),
                  //               ],
                  //             )))
                  //     : Container(),
                  // MediaQuery.of(context).orientation != Orientation.portrait
                  //     ? Padding(
                  //         padding: EdgeInsets.only(
                  //             top: MediaQuery.of(context).size.height * 0.7,
                  //             left: MediaQuery.of(context).size.width * 0.1),
                  //         child: ElevatedButton(
                  //             style: ButtonStyle(
                  //                 maximumSize: MaterialStateProperty.all<Size>(
                  //                     Size(100, 100)),
                  //                 backgroundColor:
                  //                     MaterialStateProperty.all<Color>(
                  //                         Theme.of(context).primaryColor)),
                  //             onPressed: () {
                  //               setState(() {
                  //                 if (_currentStep != 0) _currentStep -= 1;
                  //               });
                  //             },
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 FaIcon(FontAwesomeIcons.chevronLeft),
                  //                 FaIcon(FontAwesomeIcons.chevronLeft),
                  //                 FaIcon(FontAwesomeIcons.chevronLeft),
                  //               ],
                  //             )),
                  //       )
                  //     : Container()
                ]),
                // AnimatedBuilder(
                //   animation: _scrollController!,
                //   builder: (BuildContext context, child) {
                //     return ClipPath(
                //       clipper: ScrollClip(_scrollController!.value),
                //       child: Container(
                //         alignment: Alignment.center,
                //         width: double.infinity,
                //         child: Text(
                //           'What To Watch',
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold, fontSize: 40),
                //         ),
                //         height: double.infinity,
                //         color: rgetThemeColor(context),
                //         // decoration: BoxDecoration(
                //         //   gradient: LinearGradient(
                //         //       begin: Alignment.bottomLeft,
                //         //       end: Alignment.topRight,
                //         //       colors: Theme.of(context).brightness ==
                //         //               Brightness.dark
                //         //           ? [Color(0xFFE0647B), Color(0xFFFCDD89)]
                //         //           : [Color(0xFFd25ce6), Color(0xFFf90047)]),
                //         // ),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
