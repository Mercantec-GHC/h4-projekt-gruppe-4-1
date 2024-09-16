import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_first_app/config/api_config.dart';

class UpdateEventPage extends StatefulWidget {
  final String eventId;

  UpdateEventPage({required this.eventId});

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _placeIdController = TextEditingController();
  final _isPrivateController = TextEditingController();
  final _categoryController = TextEditingController();
  File? _eventPicture;
  final picker = ImagePicker();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _placeIdController.dispose();
    _isPrivateController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _eventPicture = File(pickedFile.path); // Save the selected image
      });
    }
  }

  // Function to select a date using DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (selected != null) {
      setState(() {
        _dateController.text = selected.toUtc().toString().split(' ')[0];
      });
    }
  }

  // Function to select time using TimePicker
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
        String? token = await _secureStorage.read(key: 'jwt');

        // Prepare the request body
        final body = jsonEncode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'placeId': _placeIdController.text,
          'isPrivate': _isPrivateController.text,
          'category': _categoryController.text,
          'eventPicture': _eventPicture != null ? base64Encode(await _eventPicture!.readAsBytes()) : null,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Date field
                      TextFormField(
                        controller: _dateController,
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
                      
                      // Time field
                      TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.access_time),
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

                      // Place ID field
                      TextFormField(
                        controller: _placeIdController,
                        decoration: InputDecoration(labelText: 'Place ID'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please choose a place';
                          }
                          return null;
                        },
                      ),

                      // Private/Public dropdown
                      DropdownButtonFormField<String>(
                        value: _isPrivateController.text.isNotEmpty ? _isPrivateController.text : null,
                        decoration: InputDecoration(labelText: 'Private/Public'),
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

                      // Category field
                      TextFormField(
                        controller: _categoryController,
                        decoration: InputDecoration(labelText: 'Category'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please specify a category';
                          }
                          return null;
                        },
                      ),

                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe the event';
                          } else if (value.length < 10) {
                            return 'Description must be at least 10 characters long';
                          }
                          return null;
                        },
                      ),

                      // Title field
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please title the event';
                          } else if (value.length < 10) {
                            return 'Title must be at least 10 characters long';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      // Event Picture field
                      _eventPicture == null
                          ? Text('No image selected.')
                          : Image.file(_eventPicture!),
                      const SizedBox(height: 16),
                      
                      // Select Event Picture button
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Select Event Picture"),
                      ),
                      const SizedBox(height: 16),
                      
                      // Submit button
                      ElevatedButton(
                        onPressed: _updateEvent,
                        child: Text('Update Event'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}