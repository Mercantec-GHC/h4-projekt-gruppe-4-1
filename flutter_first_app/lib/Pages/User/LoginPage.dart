import 'package:flutter/material.dart';
import 'package:flutter_first_app/Pages/Event/SeeAllEvents.dart';
import 'package:flutter_first_app/Pages/User/CreateUserPage.dart';
import 'package:flutter_first_app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_first_app/Http/User/loginuser.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(); // Secure storage for token
  final AuthService _authService = AuthService(); // Initialize AuthService
  bool _isLoading = false;

  // Handle login logic
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final loginDTO = LoginDTO(
        email: _emailController.text,
        password: _passwordController.text,
      );

      try {
        // Perform login and get the token
        final String token = await _authService.login(loginDTO); // Correctly call the method

        // Store the token securely in FlutterSecureStorage
        await _secureStorage.write(key: 'token', value: token);

        // Navigate to SeeAllEvents page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeeAllEvents()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Velkommen',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
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
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
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
                                : ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 16.0),
                                    ),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateUserPage()),
                                );
                              },
                              child: Text(
                                'Mangler du en konto? Opret en her',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

