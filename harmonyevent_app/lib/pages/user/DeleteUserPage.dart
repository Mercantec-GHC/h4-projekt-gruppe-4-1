import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harmonyevent_app/config/token.dart';
import 'package:harmonyevent_app/pages/user/UserProfilePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/pages/User/LoginPage.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';


class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;

  // Method to delete the user account
  Future<void> _deleteUser() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Fetch the token from secure storage
      //String? token = await _secureStorage.read(key: 'token');
      String? token = mytoken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Fetch the userId from secure storage if necessary
      // String? userId = await _secureStorage.read(key: 'userId');
      String? userId = myid;
      if (userId == null) {
        throw Exception('User ID not found');
      }

      // Make the DELETE request to the server
      final url = Uri.parse('${ApiConfig.apiUrl}/api/User/Delete/$userId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successfully deleted user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account successfully deleted')),
        );

        // Clear the secure storage (token, userId)
        await _secureStorage.delete(key: 'token');
        await _secureStorage.delete(key: 'userId');

        // Navigate back to login page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      } else {
        // Failed to delete user
        final errorBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: ${errorBody['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Confirmation dialog before deleting account
  Future<void> _confirmDelete() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
           builder: (context) => AlertDialog(
        title: Text(
          'Confirm Deletion',
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 234, 208, 225),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 81, 76, 76) ,
          //dropdownColor: const Color.fromARGB(255, 81, 76, 76),
        content: Text(
          //'Are you sure you want to delete ${user.Username}? This action can not be undone!',
          'Are you sure you want to delete RayTheMan? This action can not be undone!',
           style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 234, 208, 225),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); 
            },
            child: Text(
              'Cancel',
              style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 183, 211, 83),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); 
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Delete',
                style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 104, 9, 9),
                      ),
              ),
            ),   
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color.fromARGB(255, 234, 208, 225)),
          onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserProfilePage()),
          );
        },
      ),
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
            Text(
              "Harmony Event",
              style: TextStyle(
                color: const Color.fromARGB(255, 234, 208, 225),
                fontWeight: FontWeight.bold,
              ),
            ),  
          ), 
        ],
      ),
    ),
      body: Padding(
        padding: const EdgeInsets.only(left: 96.0, right: 96.0, top: 96.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) 
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Are you sure you want to delete this profile?',
                    style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 234, 208, 225),
                    ),
                  ),
                  SizedBox(height: 20),
                  GradientButton(
                    colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                    height: 40,
                    width: 350,
                    radius: 20,
                    gradientDirection: GradientDirection.leftToRight,
                    textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                    text: "Delete Profile",
                      onPressed: _confirmDelete
                  ),
                ],
              ),
      ),
    );
  }
}