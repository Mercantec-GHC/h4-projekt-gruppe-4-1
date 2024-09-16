import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harmonyevent_app/config/token.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:harmonyevent_app/config/api_config.dart';  
import 'package:flutter_gradient_button/flutter_gradient_button.dart';
import 'package:harmonyevent_app/pages/event/MyEventPage.dart';

class DeleteEventPage extends StatefulWidget {
  final String eventId;

  DeleteEventPage({required this.eventId});

  @override
  _DeleteEventPageState createState() => _DeleteEventPageState();
}

class _DeleteEventPageState extends State<DeleteEventPage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> _deleteEvent() async {
    setState(() {
      _isLoading = true; 
    });

    try { 
      //String? token = await _secureStorage.read(key: 'token');
      //MACOS TEMPORARY WORKAROUND
      String? token = mytoken;
      if (token == null) {
        throw Exception("Authentication token not found");
      }

      final url = Uri.parse('${ApiConfig.apiUrl}/api/Event/${widget.eventId}');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event deleted successfully')),
        );
        Navigator.pop(context); 
      } else {
        
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to delete event');
      }
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  Future<void> _confirmDelete() async {
    bool? confirm = await showDialog(
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
          'Are you sure you want to delete this event?',
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
      _deleteEvent(); 
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
            MaterialPageRoute(builder: (context) => MyEventsPage()),
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
                    'Are you sure you want to delete this event?',
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
                    text: "Delete Event",
                      onPressed: _confirmDelete
                  ),
                ],
              ),
      ),
    );
  }
}