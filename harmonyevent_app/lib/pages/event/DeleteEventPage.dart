import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harmonyevent_app/config/token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:harmonyevent_app/config/api_config.dart';  
import 'package:harmonyevent_app/components/custom_mainappbar.dart';

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
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); 
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); 
            },
            child: Text('Delete'),
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
      //GETs CUSTOM MAIN APPBAR FROM /components/custom_mainappbar.dart
      appBar: CustomMainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) 
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Are you sure you want to delete this event?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _confirmDelete,
                    style: ElevatedButton.styleFrom(
                      
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text('Delete Event', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
      ),
    );
  }
}