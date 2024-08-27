import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: 'Harmony Event',
        theme: ThemeData(
          useMaterial3: false,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 183, 211, 83)),
          scaffoldBackgroundColor: const Color.fromARGB(255, 36, 51, 6),
        ),
        
        home: MyHomePage(),
      ),
    );
  }
}





class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}



class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();


    return Scaffold(
      body: Column(
        children: [
          Text('How to style this?'),
          Text(appState.current.asLowerCase),
          Image(image: AssetImage('assets/images/HE_Logo.png')),
          Text('Harmony Event'),
          ElevatedButton(
            onPressed: () {
              print('button pressed!');
              
            },
            child: Text('Next >'),
          ),

        ],
        
        
      ),
      
    );
  }
}





