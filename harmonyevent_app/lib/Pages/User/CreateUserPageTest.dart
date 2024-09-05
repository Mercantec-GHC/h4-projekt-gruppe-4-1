import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:harmonyevent_app/config/api_config.dart'; 
import 'package:harmonyevent_app/models/user.dart'; 
import 'package:status_alert/status_alert.dart';
import 'package:harmonyevent_app/main.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

  void showSuccessAlert(BuildContext context) {     
    StatusAlert.show( 
      context, 
      duration: Duration(seconds: 4), 
      title: 'Success',
      

      subtitle: 'User created successfully!', 

      configuration: IconConfiguration(
        icon: Icons.check,
        color: const Color.fromARGB(255, 162, 235, 14),
                size: 180.0,
        ), 
      backgroundColor: const Color.fromARGB(255, 36, 51, 6),
      // borderRadius: BorderRadius.circular(10),
    ); 
  } 
  void showErrorAlert(BuildContext context) { 
    StatusAlert.show( 
      context, 
      duration: Duration(seconds: 2), 
      title: 'Failed to create user!', 

      subtitle: 'Please try again.', 
      configuration: IconConfiguration(
        icon: Icons.block_rounded,
        color: const Color.fromARGB(255, 162, 235, 14),
        size: 180.0,
        ), 
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
    ); 
  } 

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
    final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
        _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _postalController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<LoginDTO> createUser(
      String firstname,
      String lastname,
      String email,
      String username,
      String password,
      String address,
      String postal,
      String city) async {
    final String baseUrl = ApiConfig.apiUrl;
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'username': username,
        'password': password,
        'address': address,
        'postal': postal,
        'city': city
      }),
    );
    if (response.statusCode == 201) {
      return LoginDTO.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      
    } else {
      throw Exception('Failed to create user: ${response.statusCode} - ${response.body}');
    }
  }

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      final String firstName = _firstNameController.text;
      final String lastName = _lastNameController.text;
      final String email = _emailController.text;
      final String username = _userNameController.text;
      final String password = _passwordController.text;
      final String address = _addressController.text;
      final String postal = _postalController.text;
      final String city = _cityController.text;

      try {
        final LoginDTO newUser = await createUser(
            firstName, lastName, email, username, password, address, postal, city);


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User ${newUser.username} created successfully."),
          ),
        );
        showSuccessAlert(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EventScreen(data: 'Data sent from LoginScreen!')), // Replace with the correct page
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create user: ${e}"),
          ),
        );
              showErrorAlert(context);
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
    );
  }
}