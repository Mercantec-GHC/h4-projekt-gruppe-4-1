import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:flutter_first_app/Pages/User/LoginPage.dart';
import 'package:flutter_first_app/Pages/Event/SeeAllEvents.dart'; // Import SeeAllEvents page

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
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Fetch the userId from secure storage if necessary
      String? userId = await _secureStorage.read(key: 'userId');
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
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User clicked "No"
            },
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User clicked "Yes"
            },
            child: Text('Yes'),
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
        title: Text('Delete Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SeeAllEvents()), // Navigate to SeeAllEvents
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _confirmDelete,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
