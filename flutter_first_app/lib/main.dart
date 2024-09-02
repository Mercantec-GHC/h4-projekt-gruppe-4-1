import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_app/Pages/Event/EventPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_first_app/Pages/User/LoginPage.dart';       
import 'package:flutter_first_app/Pages/User/CreateUserPage.dart'; 
import 'package:flutter_first_app/Pages/User/DeleteUserPage.dart'; 
import 'package:flutter_first_app/Pages/User/UpdateUserPage.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 92, 208, 77)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Add the code below.
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
      case 1:
        page = CreateUserPage();
      case 2:
        page = DeleteUserPage();
      case 3:
        page = UpdateUserPage(); 
      case 4: 
        page = CreateEvent();  
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,  // ← Here.
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
                    icon:  Icon(Icons.delete),
                    label: Text("Delete Users"),  
                  ),
                  NavigationRailDestination(
                    icon:  Icon(Icons.update),
                    label: Text("Update Users"),  
                  ),
                  NavigationRailDestination(
                    icon:  Icon(Icons.event),
                    label: Text("Event"),  
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
                



