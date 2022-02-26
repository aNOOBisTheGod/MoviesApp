import 'package:flutter/material.dart';
import '../api.dart';
import '../widgets/filmcard.dart';
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

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class SearchBody extends StatefulWidget {
  const SearchBody({Key? key}) : super(key: key);

  @override
  _SearchBodyState createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody>
    with SingleTickerProviderStateMixin {
  bool _isloading = true;
  AnimationController? _controller;

  @override
  void initState() {
    getData(getRandomString(1));
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

  List data = [];

  void getData(query) async {
    data = await searchByQuery(query);
    setState(() {
      _isloading = false;
    });
  }

  TextEditingController _queryController = TextEditingController();
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
                      height: MediaQuery.of(context).size.height * 0.3,
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
                child: TextField(
                  controller: _queryController,
                  onChanged: (e) => getData(e),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: 'insert name of film',
                    iconColor: Theme.of(context).primaryColor,
                    fillColor: Theme.of(context).primaryColor,
                    focusColor: Theme.of(context).primaryColor,
                    hoverColor: Theme.of(context).primaryColor,
                    prefixIconColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          if (_isloading)
            const Center(
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
              itemCount: data.length,
              itemBuilder: (context, index) {
                return FilmCard(data[index]);
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          ]
        ],
      ),
    );
  }
}
