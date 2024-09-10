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

}
class HomeScreen extends StatelessWidget {
  //get child => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body:  Center(       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           StandardPadding(),
            Image(image: AssetImage('assets/images/HE_Logo.png'),
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
                  textStyle: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
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
      textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
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









