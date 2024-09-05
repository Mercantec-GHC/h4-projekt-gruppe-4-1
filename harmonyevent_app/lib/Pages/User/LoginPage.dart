//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';
import 'package:harmonyevent_app/Pages/Event/SeeAllEvents.dart';
import 'package:status_alert/status_alert.dart';

import 'package:harmonyevent_app/Http/User/loginuser.dart';
import 'package:harmonyevent_app/models/user.dart';
//import 'package:harmonyevent_app/main.dart';


void main() {
  runApp(MyApp());
}

  void showSuccessAlert(BuildContext context) {     
    StatusAlert.show( 
      context, 
      duration: Duration(seconds: 2), 
      title: 'Success',
      

      subtitle: 'Login completed successfully!', 

      configuration: IconConfiguration(
        icon: Icons.check,
        color: const Color.fromARGB(255, 162, 235, 14),
                size: 180.0,
        ), 
      backgroundColor: Colors.transparent,
      // borderRadius: BorderRadius.circular(10),
    ); 
  } 
  void showErrorAlert(BuildContext context) { 
    StatusAlert.show( 
      context, 
      duration: Duration(seconds: 2), 
      title: 'Invalid username or password!', 

      subtitle: 'Please try again.', 
      configuration: IconConfiguration(
        icon: Icons.block_rounded,
        color: const Color.fromARGB(255, 162, 235, 14),
        size: 180.0,
        ), 
      backgroundColor: const Color.fromARGB(255, 36, 51, 6),
    ); 
  } 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginPage',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        
      });

      final loginDTO = LoginDTO(
        email: _emailController.text,
        password: _passwordController.text,
      );

      try {
        await _authService.login(loginDTO);
        // Navigate to HomePage or another page on successful login
        showSuccessAlert(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeeAllEvents()), // Replace with the correct page
        );
      } catch (e) {
        showErrorAlert(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())), // Shows specific error message
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Image(image: AssetImage('assets/images/HE_Logo.png'),
                width: 50,
                fit: BoxFit.cover     
                ),  
              ),        

            Container(          
              child: 
                Text("Harmony Event"),
                ), 
          ],
        ),
      ),
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/background.jpg"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  
                  //child: Card(
                          
                    //color: const Color.fromARGB(255, 36, 51, 6),
  
                    // shape: RoundedRectangleBorder(
                    //   //borderRadius: BorderRadius.circular(35.0),
                    // ),
                    //elevation: 10,
                                  
                    child: Padding(
                      padding: EdgeInsets.all(66.0),
                      child: Form(
                        
                        key: _formKey,
                        child: Column(
                          
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Text(
                            //   'Velkommen',
                            //   style: TextStyle(
                            //     fontSize: 24,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),
                            //SizedBox(height: 20),
                            TextFormField(
                           
                              controller: _emailController,
                              decoration: InputDecoration(
                              labelText: 'Email',
                                       labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
          
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  
              
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                                //fillColor: const Color.fromARGB(255, 109, 190, 66),
                                //filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),

                                ),
                              ),
                              obscureText: true,
                              
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : 
                                GradientButton(
                                  colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                                  height: 40,
                                  width: 300,
                                  radius: 20,
                                  gradientDirection: GradientDirection.leftToRight,
                                  textStyle: TextStyle(color: const Color.fromARGB(255, 234, 208, 225)),
                                  text: "Login",
                                  onPressed: _login,
                                  // onPressed: () => showSuccessAlert(context), 
                                  // Navigator.push(
                                  // context,
                                  // MaterialPageRoute(
                                  //   builder: (context) => CreateUserPage(),
                                  //   ),   
                                  //);
                                  
                                ),
                                   
                                // ElevatedButton(
                                //     onPressed: _login,
                                //     style: ElevatedButton.styleFrom(
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(8.0),
                                //       ),
                                //       padding: EdgeInsets.symmetric(vertical: 16.0),
                                //     ),
                                //     child: Text(
                                //       'Login',
                                //       style: TextStyle(fontSize: 16),
                                //     ),
                                //   ),
                            //SizedBox(height: 20),
                            // TextButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => CreateUserPage()),
                            //     );
                            //   },
                            //   child: Text(
                            //     'Mangler du en konto? Opret en her',
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       color: Theme.of(context).primaryColor,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  //),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}