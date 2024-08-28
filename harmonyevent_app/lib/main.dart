//import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

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
        //title: 'Harmony Event',
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
  //var current = WordPair.random()
    void getNext() {
    //current = WordPair.random();
    notifyListeners();
  } 
}

class MyHomePage extends StatelessWidget {
  get child => null;

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    //var pair = appState.current;

    return Scaffold(
      body:  Center(
        child: Column(
          children: [
            Padding(  
              padding: const EdgeInsets.all(35),
            ),
            //BigCard(pair: pair),
            Image(image: AssetImage('assets/images/HE_Logo.png'),
              //height: 400,
              width: 350,
              fit: BoxFit.cover
            ),
            Padding(  
              padding: const EdgeInsets.all(35),
              child: LogoText(),
            ),
            GradientButton(
              colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
              height: 40,
              width: 300,
              radius: 20,
              gradientDirection: GradientDirection.leftToRight,
              textStyle: TextStyle(color: const Color.fromARGB(255, 234, 208, 225)),
              text: "Login",
                onPressed: () {
                print("Button clicked");
              },
            ),
            Padding(  
              padding: const EdgeInsets.all(15),
            ),
            GradientButton(
              colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
              height: 40,
              width: 300,
              radius: 20,
              gradientDirection: GradientDirection.leftToRight,
              textStyle: TextStyle(color: const Color.fromARGB(255, 234, 208, 225)),
              text: "Create User",
              onPressed: () {
                print("Button clicked");
              },
            ),
          ],
        ),
      ),
    ); 
  }
}

class LogoText extends StatelessWidget {
  const LogoText({
    super.key,
  });

  final txt = "Harmony Event";

  @override
  Widget build(BuildContext context) {
      var theme = Theme.of(context);
      var style = theme.textTheme.displaySmall!.copyWith(
      color: const Color.fromARGB(255, 234, 208, 225),
    );
    return Text(txt, style: style);
  }
}

// class MainButtonText extends StatelessWidget {
//   const MainButtonText({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(15),
//       child: Text('Next >'),
//     );   
//   }
// }

// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );
//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(pair.asLowerCase, style: style),
//       ),
//     );
//   }
// }





