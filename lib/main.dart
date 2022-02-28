import 'package:flutter/material.dart';
import 'package:movies/api.dart';
import 'package:movies/functions.dart';
import 'package:movies/screens/favourites.dart';
import 'package:movies/screens/home.dart';
import 'package:movies/screens/searchbody.dart';
import 'package:movies/screens/settings.dart';
import 'package:movies/widgets/background.dart';
import './themes.dart';
import 'package:provider/provider.dart';
import './screens/introduction.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:glassmorphism/glassmorphism.dart';

void main() {
  createSession();
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
          home: HomePage(),
          // home: IntoduceScreen(),
          routes: {
            FavouritesScreeen.routeName: (ctx) => FavouritesScreeen(),
            IntoduceScreen.routeName: (ctx) => IntoduceScreen()
          },
        );
      }),
    );
  }
}

Widget returnBody(index) {
  if (index == 0) {
    return HomeBody();
  } else if (index == 1) {
    return Favourites();
  } else if (index == 2) {
    return SearchBody();
  } else {
    return SettingsBody();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: getThemeColor(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          backgroundColor: Colors.transparent,
          opacity: .2,
          currentIndex: _currentIndex,
          onTap: (idx) {
            setState(() {
              _currentIndex = idx!;
            });
          },
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 8,
          fabLocation: BubbleBottomBarFabLocation.end, //new
          hasNotch: true, //new
          hasInk: true, //new, gives a cute ink effect
          inkColor:
              Colors.black12, //optional, uses theme color if not specified
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.dashboard,
                  color: rgetThemeColor(context),
                ),
                activeIcon: Icon(
                  Icons.dashboard,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text("Home")),
            BubbleBottomBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.star,
                  color: rgetThemeColor(context),
                ),
                activeIcon: Icon(
                  Icons.star,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text("Favourites")),
            BubbleBottomBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.search_off,
                  color: rgetThemeColor(context),
                ),
                activeIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text("Search")),
            BubbleBottomBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(
                  Icons.settings,
                  color: rgetThemeColor(context),
                ),
                activeIcon: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text("Settings"))
          ],
        ),
        floatingActionButton:
            Consumer(builder: (context, ThemeModel themeNotifier, child) {
          return FloatingActionButton(
            tooltip: "Change Theme",
            child: AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  child: child,
                  opacity: animation,
                );
              },
              duration: Duration(milliseconds: 200),
              child: Icon(
                themeNotifier.isDark ? Icons.nightlight_round : Icons.wb_sunny,
                key: ValueKey(themeNotifier.isDark),
              ),
            ),
            onPressed: () async {
              themeNotifier.isDark
                  ? themeNotifier.isDark = false
                  : themeNotifier.isDark = true;
            },
          );
        }),
        // drawer: AppDrawer(),
        // body: Container(
        //   height: double.infinity,
        //   color: getThemeColor(context),
        //   // child: returnBody(_currentIndex)
        // ),
        body: AppBackground(
          child: returnBody(_currentIndex),
        ));
  }
}
