import 'package:flutter/material.dart';

import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_first_app/config/api_config.dart';





class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HTTP Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter HTTP Example'),
        ),
        body: CreateEvent(),
      ),
    );
  }
}

class CreateEvent extends StatefulWidget {
  @override
  CreateEventState createState() {
    return CreateEventState();
  }
}

class CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  final String baseUrl = ApiConfig.apiUrl;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController user_idController = TextEditingController();
  final TextEditingController place_idController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
           

  @override
  void dispose() {
   
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
   
      final date = dateController.text;
      final user_id = user_idController;
      final place_id = place_idController;
      final type = typeController.text;
      final category = categoryController.text;
      final description = descriptionController.text;

      // Call the method to send data to the backend
      try {
        final EventDTO newEventDTO = await createevent(
           user_id as String, place_id as String ,date, type, category, description);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Description ${newEventDTO.description} created successfully."),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create Event: $e"),
          ),
        );
      }
    }
  }

  Future<EventDTO> createevent(String user_id, String place_id, String date, String type,String category,String description) async 
    {
    final String baseUrl = ApiConfig.apiUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/api/event/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: json.encode(<String, String>{
          //'date': date,
          'user_id': user_id,
          'place_id':place_id,
          'type':type,
          'category':category,
          'description':description,
        }),
      );
      if (response.statusCode == 201) {
      return EventDTO.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create event: ${response.statusCode} - ${response.body}');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: dateController,
       
              decoration: InputDecoration(labelText: 'Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose date';
                }
                return null;
              },
            ),
                TextFormField(
              controller: place_idController,
              decoration: InputDecoration(labelText: 'Where'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose place';
                }
                return null;
              },
            ), 
                TextFormField(
              controller: user_idController,
              decoration: InputDecoration(labelText: 'Who created'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose him';
                }
                return null;
              },
            ), 
            TextFormField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'What type';
                }
                return null;
              },
            ),
             TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'What category';
                }
                return null;
              },
            ),
             TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Descripe event';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

