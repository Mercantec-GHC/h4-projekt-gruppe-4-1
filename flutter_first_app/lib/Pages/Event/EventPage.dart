import 'package:flutter/material.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_first_app/config/api_config.dart';




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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    print(selected);



    if (selected != null) {
      setState(() {
        dateController.text = selected.toUtc().toString().split(' ')[0]; 
      });
    }
  }

Future<void> _submitData() async {
  if (_formKey.currentState!.validate()) {
    final String date = dateController.text; 
    final String place_id = place_idController.text; 
    final String type = typeController.text;
    final String category = categoryController.text;
    final String description = descriptionController.text;

    
    try {
      final EventDTO newEventDTO = await createevent(
        place_id, date, type, category, description);

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

  Future<EventDTO> createevent(String place_id, String date, String type, String category, String description) async {
  final String baseUrl = ApiConfig.apiUrl;
  final response = await http.post(
    Uri.parse('$baseUrl/api/event/create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(<String, String>{
      'date': date,
      'place_id': place_id,
      'type': type,
      'category': category,
      'description': description,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: dateController,
              readOnly: true, 
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose a date';
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
                  return 'Describe event';
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
      )
    );
  }
}


