import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_first_app/Pages/Event/EventPage.dart';
import 'package:flutter_first_app/Pages/User/CreateUserPage.dart';
import 'package:flutter_first_app/Pages/User/DeleteUserPage.dart';
import 'package:flutter_first_app/Pages/User/UpdateUserPage.dart';
import 'package:flutter_first_app/Pages/Event/SeeAllEvents.dart';
import 'package:flutter_first_app/Pages/User/LoginPage.dart';
import 'package:flutter_first_app/Http/User/loginuser.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => MyAppState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(), // Check if the user is logged in on startup
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(), 
              ),
            ),
          );
        } else {
          bool isLoggedIn = snapshot.data ?? false; 
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 92, 208, 77),
              ),
            ),
            home: isLoggedIn ?  SeeAllEvents(): LoginPage(), 
          );
        }
      },
    );
  }
}

class MyAppState extends ChangeNotifier {
  
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  
  var users = <WordPair>[];

  void toggleFavorite() {
    if (users.contains(current)) {
      users.remove(current);
    } else {
      users.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = LoginPage();
        break;
      case 1:
        page = CreateUserPage();
        break;
      case 2:
        page = DeleteUserPage();
        break;
      case 3:
        page = UpdateUserPage();
        break;
      case 4:
        page = CreateEvent(); 
        break;
      case 5:
        page = SeeAllEvents();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.login),
                    label: Text('Login'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.create),
                    label: Text('Create Users'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.delete),
                    label: Text("Delete Users"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.update),
                    label: Text("Update Users"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.event),
                    label: Text("Plan"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.event_available),
                    label: Text("See All Events"),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
                
                


