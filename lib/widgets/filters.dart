import 'package:flutter/material.dart';
import '../usersettings.dart';
import '../functions.dart';
import 'package:glassmorphism/glassmorphism.dart';

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GlassmorphicContainer(
            width: double.infinity,
            height: 500,
            padding: EdgeInsets.all(20),
            borderRadius: 20,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: genres.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          userGenres
                                  .contains(genres[genres.keys.toList()[index]])
                              ? userGenres
                                  .remove(genres[genres.keys.toList()[index]])
                              : userGenres
                                  .add(genres[genres.keys.toList()[index]]);

                          setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: userGenres.contains(
                                    genres[genres.keys.toList()[index]])
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.5)
                                : null,
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(
                            //     color: !userGenres.contains(
                            //             genres[genres.keys.toList()[index]])
                            //         ? Theme.of(context)
                            //             .primaryColor
                            //             .withOpacity(0.5)
                            //         : Colors.transparent)
                          ),
                          child: Center(
                              child: Text(
                            '${genres.keys.toList()[index]}',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
