
import 'package:flutter/material.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/services/login_service.dart';
import 'package:harmonyevent_app/pages/LoginPage.dart';   
import 'package:harmonyevent_app/pages/CreateUserPage.dart';  
import 'package:harmonyevent_app/pages/EventPage.dart'; 

void main() {
  runApp(
    MyApp(
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
        } 
        else {
          bool isLoggedIn = snapshot.data ?? false; 
          return MaterialApp(
            title: 'Harmony Event',
            theme: ThemeData(
              useMaterial3: false,
              colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 183, 211, 83)),
              scaffoldBackgroundColor: const Color.fromARGB(255, 36, 51, 6),
              fontFamily: 'Purisa', 
            ),
          home: isLoggedIn ? EventPage() : HomeScreen(), 
          );
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body:  Center(       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(  
              padding: const EdgeInsets.all(15),
            ),
            Image(image: AssetImage('assets/images/HE_Logo.png'),
              width: 350,
              fit: BoxFit.cover
            ),
            Padding(  
              padding: const EdgeInsets.all(35),
              child: Text(
                "Harmony Event",
                style: TextStyle(
                  color: const Color.fromARGB(255, 234, 208, 225),
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),
              )      
            ),
            GradientButton(
              colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
              height: 40,
              width: 350,
              radius: 20,
              gradientDirection: GradientDirection.leftToRight,
              textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              text: "Login",
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),  
                );
              },
            ),
            Padding(  
              padding: const EdgeInsets.all(15),
            ),
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










