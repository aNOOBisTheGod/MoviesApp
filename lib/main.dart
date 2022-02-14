import 'package:flutter/material.dart';
import 'package:movies/api.dart';
import 'package:movies/widgets/appdrawer.dart';
import 'package:movies/widgets/filmcard.dart';
import './themes.dart' show ThemeModel, light, dark;
import 'package:provider/provider.dart';
import './usersettings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeNotifier.isDark ? dark : light,
          debugShowCheckedModeBanner: false,
          home: HomePage(1),
        );
      }),
    );
  }
}

class HomePage extends StatefulWidget {
  int page;
  HomePage(this.page);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? films;
  bool _isLoading = true;
  bool _filters = false;
  bool _filtersChanged = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    films = await getPopular(widget.page);
    setState(() {
      print('loading done');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => getGenres(),
        // ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Here are the best daily films'),
        ),
        drawer: AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.orange,
              ))
            : Container(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     GestureDetector(
                      //         onTap: () {
                      //           _filtersChanged = false;
                      //           setState(() {});
                      //         },
                      //         child: AnimatedContainer(
                      //             alignment: Alignment.center,
                      //             width: 200,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(20),
                      //               color: _filtersChanged
                      //                   ? Theme.of(context).primaryColor
                      //                   : Colors.black.withOpacity(1),
                      //             ),
                      //             height: _filtersChanged ? 40 : 0,
                      //             duration: Duration(milliseconds: 300),
                      //             child: _filtersChanged
                      //                 ? Text('Search With Filters')
                      //                 : Container())),
                      //     Padding(
                      //       padding: const EdgeInsets.all(20.0),
                      //       child: Text(
                      //         'Filters',
                      //         style: TextStyle(fontSize: 20),
                      //       ),
                      //     ),
                      //     IconButton(
                      //         onPressed: () {
                      //           setState(() {
                      //             _filters = !_filters;
                      //           });
                      //         },
                      //         icon: Icon(Icons.settings_suggest_outlined))
                      //   ],
                      // ),
                      // AnimatedContainer(
                      //   padding: EdgeInsets.all(20),
                      //   duration: Duration(milliseconds: 300),
                      //   height: !_filters
                      //       ? 0
                      //       : MediaQuery.of(context).size.height * 0.5,
                      //   curve: Curves.fastOutSlowIn,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(20),
                      //     color:
                      //         Theme.of(context).brightness == Brightness.light
                      //             ? Colors.grey[350]
                      //             : Colors.grey[800],
                      //   ),
                      //   child: GridView.builder(
                      //       gridDelegate:
                      //           const SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 3,
                      //       ),
                      //       itemCount: genres.keys.length,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: GestureDetector(
                      //             onTap: () {
                      //               userGenres.contains(
                      //                       genres[genres.keys.toList()[index]])
                      //                   ? userGenres.remove(
                      //                       genres[genres.keys.toList()[index]])
                      //                   : userGenres.add(genres[
                      //                       genres.keys.toList()[index]]);
                      //               _filtersChanged = true;
                      //               setState(() {});
                      //             },
                      //             child: AnimatedContainer(
                      //               duration: Duration(milliseconds: 300),
                      //               decoration: BoxDecoration(
                      //                   color: userGenres.contains(genres[
                      //                           genres.keys.toList()[index]])
                      //                       ? Theme.of(context).primaryColor
                      //                       : Colors.black,
                      //                   borderRadius: BorderRadius.circular(20),
                      //                   border: Border.all(
                      //                       color: Theme.of(context)
                      //                           .primaryColor)),
                      //               child: Center(
                      //                   child: Text(
                      //                       '${genres.keys.toList()[index]}')),
                      //             ),
                      //           ),
                      //         );
                      //       }),
                      // ),
                      // TextField(
                      //   onSubmitted: (query) =>
                      //       searchByQuery(query).then((value) {
                      //     setState(() {
                      //       films = value;
                      //     });
                      //   }),
                      // ),
                      ListView.builder(
                        itemCount: films!.length,
                        itemBuilder: (context, index) {
                          return FilmCard(films![index]);
                        },
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.page > 1
                                ? GestureDetector(
                                    onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage(widget.page - 1))),
                                    child: Container(
                                      child: Icon(Icons.arrow_left),
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Text(
                                  widget.page.toString(),
                                  style: TextStyle(fontSize: 24),
                                ),
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(widget.page + 1))),
                              child: Container(
                                child: Icon(Icons.arrow_right),
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
