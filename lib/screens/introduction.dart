import 'package:flutter/material.dart';
import '../themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntoduceScreen extends StatefulWidget {
  static const routeName = '/introduce';
  const IntoduceScreen({Key? key}) : super(key: key);

  @override
  _IntoduceScreenState createState() => _IntoduceScreenState();
}

class _IntoduceScreenState extends State<IntoduceScreen> {
  int _currentStep = 0;
  bool _updated = false;

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
          'Now application is in development stage, so there will be a lot of new features! Also there will be good if You will leave feedback about application on GitHub(where I guess You\'ve download it).',
    }
  ];
  @override
  Widget build(BuildContext context) {
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                'Welcome to MoviesApp',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                int sensitivity = 10;
                if (details.primaryVelocity! > sensitivity &&
                    _currentStep != 0) {
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
              child: Stack(
                children: [
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
                      top: MediaQuery.of(context).size.height * 0.45,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
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
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
