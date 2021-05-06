import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'business.dart';
import 'map.dart';
import 'recreation.dart';
import 'event.dart';
import 'hike.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

// ThemeData Colors
MaterialColor colorPrimary = createMaterialColor(Color(0xFF01579b));
MaterialColor colorAccent = createMaterialColor(Color(0xFFf4a024));
MaterialColor colorBackground = createMaterialColor(Color(0xFFB4D4ED));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => InfoWindowModel(),
    child: MyApp(),
  ),
  );
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Vanderhoof App Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          primarySwatch: colorPrimary,
          primaryColor: colorPrimary,
          accentColor: colorAccent,
          // canvasColor: colorBackground,
        ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              // Check for errors
              if (snapshot.hasError) {
                return Text("Something went wrong: ${snapshot.hasError}");
                // Once complete, show your application
              } else if (snapshot.connectionState == ConnectionState.done) {
                return MyHomePage(title: 'Landing Page');
              } else {
                // Otherwise, show something whilst waiting for initialization to complete
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _children = [
    BusinessState(),
    Event(),
    Hike(),
    Recreation(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Businesses',
            backgroundColor: colorPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
            backgroundColor: colorPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Hiking',
            backgroundColor: colorPrimary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: 'Recreational',
            backgroundColor: colorPrimary,
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        selectedItemColor: colorAccent,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}

// This method uses a Color with a hex code to create a MaterialColor object
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
