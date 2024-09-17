import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:harmonyevent_app/config/auth_workaround.dart';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:harmonyevent_app/pages/event/MyEventPage.dart';


class UpdateEventPage extends StatefulWidget {
  final String eventId;

  UpdateEventPage({required this.eventId});

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  final _formKey = GlobalKey<FormState>();
  File? EventPicture; // To store the selected image
  final picker = ImagePicker(); // Image picker instance
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _isPrivateController = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        EventPicture = File(pickedFile.path); // Save the selected image
      });
    }
  }

  // Function to select a date using DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (selected != null) {
      setState(() {
        _dateController.text = selected.toUtc().toString().split(' ')[0]; // Update date
      });
    }
  }
  Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? selected = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (selected != null) {
    setState(() {
      _timeController.text = selected.format(context); 
      });
    }
  }

  // Method to update the event
  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        // Get JWT token from secure storage
        //String? token = await _secureStorage.read(key: 'token');
        String? token = mytoken;
        if (token == null) {
          throw Exception("Authentication token not found");
        }

        // Prepare the request body
        final body = jsonEncode({
          'date': _dateController.text,
          'title': _titleController.text,
          'description': _descriptionController.text,
        });

        // Make the PUT request to update the event
        final url = Uri.parse('${ApiConfig.apiUrl}/api/Event/${widget.eventId}');
        final response = await http.put(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: body,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event updated successfully')),
          );
          Navigator.pop(context); // Go back after update
        } else {
          final errorBody = jsonDecode(response.body);
          throw Exception(errorBody['message'] ?? 'Failed to update event');
        }
      } 
      catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } 
      finally {
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
        padding: const EdgeInsets.only(left: 66.0, right: 66.0, top: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //SELECT IMAGE
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image,
                  color: const Color.fromARGB(255, 183, 211, 83),),
                  label: Text('Choose image'),              
              ),
              EventPicture != null ? Image.file(
                EventPicture!,
                height: 50,
              )
              : Text(
                'Prefered size 500x281 pixels',
                style: TextStyle(
                  color: const Color.fromARGB(255, 183, 211, 83)
                ),
              ),
              SizedBox(height: 10),

              //SELECT DATE AND TIME
              TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                controller: _dateController,
                readOnly: true, 
                decoration: InputDecoration(
                  labelText: 'Occurs',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                          color: const Color.fromARGB(255, 183, 211, 83),
                      ),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose date and time';
                  }
                  return null;
                },
              ),
              // Time field
              TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.access_time,
                      color: const Color.fromARGB(255, 183, 211, 83),
                    ),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose a time';
                  }
                  return null;
                },
              ),
        
              //SELECT LOCATION
              TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose location';
                  }
                  return null;
                },
              ),

              //SELECT TITLE 
              TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please choose title';
                  }
                  return null;
                },
              ),
 
              //SELECT CATEGORY
              DropdownButtonFormField<String>(
                dropdownColor: const Color.fromARGB(255, 81, 76, 76),
                borderRadius: BorderRadius.circular(8.0),
                  style: TextStyle(
                    color: Color.fromARGB(255, 234, 208, 225),
                    fontFamily: "Purisa",
                  ),
                value: _categoryController.text.isNotEmpty ? _categoryController.text : null,
                decoration: InputDecoration(
                  //hoverColor: const Color.fromARGB(255, 36, 51, 6),
                  labelText: 'Category',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83)),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'Anniversary', child: Text('Anniversary')),
                  DropdownMenuItem(value: 'Birthday', child: Text('Birthday')),
                  DropdownMenuItem(value: 'Concert', child: Text('Concert')),
                  DropdownMenuItem(value: 'Corporate', child: Text('Corporate')),
                  DropdownMenuItem(value: 'Convention', child: Text('Convention')),
                  DropdownMenuItem(value: 'Exhibition', child: Text('Exhibition')),
                  DropdownMenuItem(value: 'Festival', child: Text('Festival')),
                  DropdownMenuItem(value: 'Lecture', child: Text('Lecture')),
                  DropdownMenuItem(value: 'Networking', child: Text('Networking')),
                  DropdownMenuItem(value: 'Party', child: Text('Party')),
                  DropdownMenuItem(value: 'Reception', child: Text('Reception')),
                  DropdownMenuItem(value: 'Sports', child: Text('Sports')),
                  DropdownMenuItem(value: 'Seminar', child: Text('Seminar')),
                  DropdownMenuItem(value: 'Team builing', child: Text('Team builing')),
                  DropdownMenuItem(value: 'Wedding', child: Text('Wedding')),
                  DropdownMenuItem(value: 'Workshop', child: Text('Workshop')),
                  DropdownMenuItem(value: 'Others', child: Text('Others')),
                ],
                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value!;  
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please chose category';
                  }
                  return null;
                },
              ),
              // WRITE DESCRIPTION
              TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                maxLines: 3,
                minLines: 3,
                controller: _descriptionController,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Description',   
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please make decription';
                }
                return null;
                },
              ),

              // Private/Public dropdown
              DropdownButtonFormField<String>(
                borderRadius: BorderRadius.circular(8.0),
                dropdownColor: const Color.fromARGB(255, 81, 76, 76),
                style: TextStyle(
                  color: Color.fromARGB(255, 234, 208, 225),
                  fontFamily: "Purisa",
                ),
                value: _isPrivateController.text.isNotEmpty ? _isPrivateController.text : null,
                decoration: InputDecoration(
                  labelText: 'Private/Public',
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 183, 211, 83), 
                    //fontSize: 14.0
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'true', child: Text('Private')),
                  DropdownMenuItem(value: 'false', child: Text('Public')),
                ],
                onChanged: (value) {
                  setState(() {
                    _isPrivateController.text = value!;  
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify if the event is private or public';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),     
              SizedBox(height: 20),

              _isLoading ? CircularProgressIndicator() : 
              GradientButton(
                colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
                height: 40,
                width: 350,
                radius: 20,
                gradientDirection: GradientDirection.leftToRight,
                textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                text: "Update Event",
                onPressed: _updateEvent
              ),
            ],
          ),
        ),
      ),
    );
  }
}