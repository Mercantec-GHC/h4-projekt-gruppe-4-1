import 'package:flutter/material.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker

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

  File? _image; // To store selected image
  final picker = ImagePicker(); // Image picker instance

  @override
  void dispose() {
    super.dispose();
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // or ImageSource.camera
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Save the selected image
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

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
        final EventDTO newEventDTO = await createEvent(
          place_id,
          date,
          type,
          category,
          description,
          _image, // Pass the image file for upload
        );

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

  // Function to create event with image upload
  Future<EventDTO> createEvent(String place_id, String date, String type, String category, String description, File? image) async {
    final String baseUrl = ApiConfig.apiUrl;
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/event/create'));

    request.fields['place_id'] = place_id;
    request.fields['date'] = date;
    request.fields['type'] = type;
    request.fields['category'] = category;
    request.fields['description'] = description;

    // Attach the image file if it exists
    if (image != null) {
      var imageStream = http.ByteStream(image.openRead());
      var imageLength = await image.length();
      request.files.add(
        http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: image.path.split('/').last,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return EventDTO.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to create event: ${response.statusCode}');
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
              SizedBox(height: 10),
              // Image upload button
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Pick Event Image'),
              ),
              SizedBox(height: 10),
              _image != null
                  ? Image.file(
                      _image!,
                      height: 150,
                    )
                  : Text('No image selected'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


