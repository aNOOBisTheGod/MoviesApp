import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AppBackground extends StatefulWidget {
  Widget child;
  AppBackground({required this.child});

  @override
  _AppBackgroundState createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ColorFiltered(
          colorFilter: Theme.of(context).brightness != Brightness.dark
              ? ColorFilter.matrix([
                  -1,
                  0,
                  0,
                  0,
                  255,
                  0,
                  -1,
                  0,
                  0,
                  255,
                  0,
                  0,
                  -1,
                  0,
                  255,
                  0,
                  0,
                  0,
                  1,
                  0,
                ])
              : ColorFilter.srgbToLinearGamma(),
          child: Image.asset(
            'assets/images/preview.jpg',
            height: double.infinity,
          )),
      GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 0,
        blur: 20,
        border: 2,
        linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffffff).withOpacity(0.1),
              Color(0xFFFFFFFF).withOpacity(0.05),
            ],
            stops: [
              0.1,
              1,
            ]),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffffff).withOpacity(0.0),
            Color((0xFFFFFFFF)).withOpacity(0.0),
          ],
        ),
        child: widget.child,
      ),
    ]);
  }
}
