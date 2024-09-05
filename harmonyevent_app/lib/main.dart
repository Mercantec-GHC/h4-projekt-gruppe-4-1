//import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/Pages/User/LoginPage.dart';   
import 'package:harmonyevent_app/Pages/User/CreateUserPage.dart';   

void main() {
  runApp(
    MyApp(

    ));
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
          fontFamily: 'Purisa', 
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  //var current = WordPair.random()
  // void getNext() {
  //   //current = WordPair.random();
  //   notifyListeners();
  // } 
  //void nextPageLogin() {

  //} 
}
class HomeScreen extends StatelessWidget {
  //get child => null;
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    //var pair = appState.current;

    return Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           StandardPadding(),
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

            ButtonStyling(
            ),

            StandardPadding(),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GradientButton(
                  colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                  height: 40,
                  width: 350,
                  radius: 20,
                  gradientDirection: GradientDirection.leftToRight,
                  textStyle: TextStyle(color: const Color.fromARGB(255, 234, 208, 225)),
                  text: "Create User",
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateUserPage(),
                      ),   
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}

class StandardPadding extends StatelessWidget {
  const StandardPadding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(  
      padding: const EdgeInsets.all(15),
    );
  }
}

class ButtonStyling extends StatelessWidget {
  const ButtonStyling({
    super.key,
  });

  final txt = "Login";

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
      height: 40,
      width: 350,
      radius: 20,
      gradientDirection: GradientDirection.leftToRight,
      textStyle: TextStyle(color: const Color.fromARGB(255, 234, 208, 225)),
      text: txt,
        onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),  
        );
      },
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


//Event screen//
class EventScreen extends StatelessWidget {
  final String data;

  EventScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.menu),
  //title: Text('Page title'),
  actions: <Widget>[
            IconButton(
      icon: Icon(
        Icons.add_circle_outline, 
        color: const Color.fromARGB(255, 183, 211, 54)),
       tooltip: "Create Event",
                onPressed: () {
          print("Hmm");
        }
    ),
    IconButton(
      //padding: EdgeInsets.symmetric(horizontal: 18),
      icon: const Icon(
        Icons.favorite, 
        color: const Color.fromARGB(255, 183, 211, 54)),
        tooltip: "Favorite Events",
        onPressed: () {
          print("Hmm");
        }
    ),
    IconButton(
      icon: const Icon(
        Icons.search, 
        color: const Color.fromARGB(255, 183, 211, 54)),
        tooltip: "Search Events",
                onPressed: () {
          print("Hmm");
        }
    ),
    IconButton(
      
      icon: const Icon(
        Icons.account_circle, 
        color: const Color.fromARGB(255, 183, 211, 54)),
  
       tooltip: "Your account",
                onPressed: () {
          print("Hmm");
        }
    ),

  ],
  //backgroundColor: Colors.purple,
        title: Row(
          children: [
            Container(
              // height: 120.0,
              // width: 120.0,
              //child: const Align(
              //alignment: FractionalOffset(1, 0),
              child: Image(image: AssetImage('assets/images/HE_Logo.png'),
                //height: 400,
                width: 50,
                fit: BoxFit.cover     
                ),  
              ),        
            //),
            Container(          
              // height: 120.0,
              // width: 120.0,
              //child: const Align(
              //alignment: FractionalOffset(0.6, 0.5),
              child: 
                Text("Harmony Event (EventScreen)"),
                ), 
            //),
          ],
        ),
      ),
      
      body: Center(
       child: Column(
         children: [
            StandardPadding(),
            Text(data),

         ],

       ),
     

      ),
    );
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





