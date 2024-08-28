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

    void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}



class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Column(
        children: [
          Text('How to style this?'),
          BigCard(pair: pair),
          Image(image: AssetImage('assets/images/HE_Logo.png')),
          Padding(  
            padding: const EdgeInsets.all(15),
            child: Text('Harmony Event'),
          ),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
              
            },
            child: Text('Next >'),
          ),

        ],
        
        
      ),
      
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}





