
// import 'package:flutter/material.dart';
// import 'package:flutter_gradient_button/flutter_gradient_button.dart';

// import 'package:status_alert/status_alert.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:harmonyevent_app/models/login_model.dart';
// import 'package:harmonyevent_app/services/login_service.dart';

// import 'package:harmonyevent_app/pages/EventPage.dart';


// void main() {
//   runApp(MyApp());
// }

// void showSuccessAlert(BuildContext context) {     
//   StatusAlert.show( 
//     context, 
//     duration: Duration(seconds: 2), 
//     title: 'Success',
//     subtitle: 'Login completed successfully!', 
//     configuration: IconConfiguration(
//       icon: Icons.check,
//       color: const Color.fromARGB(255, 162, 235, 14),
//               size: 180.0,
//       ), 
//     backgroundColor: Colors.transparent,
//     // borderRadius: BorderRadius.circular(10),
//   ); 
// } 
// void showErrorAlert(BuildContext context) { 
//   StatusAlert.show( 
//     context, 
//     duration: Duration(seconds: 2), 
//     title: 'Invalid username or password!', 
//     subtitle: 'Please try again.', 
//     configuration: IconConfiguration(
//       icon: Icons.block_rounded,
//       color: const Color.fromARGB(255, 162, 235, 14),
//       size: 180.0,
//       ), 
//     backgroundColor: const Color.fromARGB(255, 36, 51, 6),
//   ); 
// } 

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'LoginPage',
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final FlutterSecureStorage _secureStorage = FlutterSecureStorage(); // Secure storage for token
//   final AuthService _authService = AuthService(); // Initialize AuthService
//   bool _isLoading = false;

//   void _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;      
//       });

//       final loginDTO = LoginDTO(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );

//       try {
//          // Perform login and get the token
//         final String token = await _authService.login(loginDTO); // Correctly call the method

//         // Store the token securely in FlutterSecureStorage
//         await _secureStorage.write(key: 'token', value: token);
        
//         //await _authService.login(loginDTO);
//         // Navigate to HomePage or another page on successful login
//         showSuccessAlert(context);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => EventPage()), // Replace with the correct page
//         );
//       } 
//       catch (e) {
//         showErrorAlert(context);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.toString())), // Shows specific error message
//         );
//       } 
//       finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Container(
//               child: Image(image: AssetImage('assets/images/HE_Logo.png'),
//                 width: 50,
//                 fit: BoxFit.cover     
//                 ),  
//               ),        
//             Container(          
//               child: 
//                 Text("Harmony Event"),
//                 ), 
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: 500),
//                 child: SingleChildScrollView(                                
//                     child: Padding(
//                       padding: EdgeInsets.all(66.0),
//                       child: Form(         
//                         key: _formKey,
//                         child: Column(                         
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             TextFormField(
//                               style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
//                               controller: _emailController,
//                               decoration: InputDecoration(
//                               labelText: 'Email',
//                               labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),               
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8.0),                                              
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 30),
//                             TextFormField(
//                                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
//                               controller: _passwordController,
//                               decoration: InputDecoration(
//                                 labelText: 'Password',
//                                 labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
//                                 //fillColor: const Color.fromARGB(255, 109, 190, 66),
//                                 //filled: true,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                               obscureText: true,                              
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 20),
//                             _isLoading ? Center(child: CircularProgressIndicator()) : GradientButton(
//                               colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
//                               height: 40,
//                               width: 300,
//                               radius: 20,
//                               gradientDirection: GradientDirection.leftToRight,
//                               textStyle: TextStyle(color: const Color.fromARGB(255, 234, 208, 225)),
//                               text: "Login",
//                               onPressed: _login,                                 
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }