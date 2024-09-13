import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_first_app/models/event.dart';
import 'package:flutter_first_app/services/event_service.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvent extends StatefulWidget {
  @override
  CreateEventState createState() {
    return CreateEventState();
  }
}

class CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

  
  final TextEditingController dateController = TextEditingController();
  final TextEditingController placeIdController = TextEditingController();
  final TextEditingController isPrivateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? EventPicture; 
  final picker = ImagePicker(); 
  final EventService _eventService = EventService(); 

  
  @override
  void dispose() {
    dateController.dispose();
    placeIdController.dispose();
    isPrivateController.dispose();
    categoryController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        EventPicture= File(pickedFile.path); // Save the selected image
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
        dateController.text = selected.toUtc().toString().split(' ')[0]; // Update date
      });
    }
  }

  // Function to handle form submission
  Future<void> _submitData() async {
  if (_formKey.currentState!.validate()) {
    final String date = dateController.text;
    final String placeId = placeIdController.text;
    final String isPrivate = isPrivateController.text;
    final String title = titleController.text;
    final String category = categoryController.text;
    final String description = descriptionController.text;
    
    File? eventPicture; // Declared as a nullable File

    // Ensure that the user has picked an image
    if (EventPicture != null) {
      eventPicture = EventPicture; // Set the image from the file picker
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an event picture."),
        ),
      );
      return;
    }

    try {
      // Call EventService to create the event
      final CreateEventDTO newEventDTO = await _eventService.createEvent(
        placeId,
        date,
        category,
        isPrivate,
        title,
        description,
        eventPicture, // Pass the image file for upload
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Event '${newEventDTO.title}' created successfully."),
        ),
      );

      // Reset the form after successful submission
      _formKey.currentState?.reset();
      setState(() {
        EventPicture = null; // Clear the selected image
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create event: $e"),
        ),
      );
    }
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
          child: SingleChildScrollView(
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
                  controller: placeIdController,
                  decoration: InputDecoration(labelText: 'Place ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please choose a place';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                value: isPrivateController.text.isNotEmpty ? isPrivateController.text : null, // Default value
                decoration: InputDecoration(labelText: 'Private/Public'),
                items: [
                DropdownMenuItem(value: 'true', child: Text('Private')),
                DropdownMenuItem(value: 'false', child: Text('Public')),
                ],
                onChanged: (value) {
                setState(() {
                isPrivateController.text = value!;  // Store the selected value in the controller
                  });
                },
                validator: (value) {
                if (value == null || value.isEmpty) {
                return 'Please specify if the event is private or public';
                }
                return null;
                },
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please specify a category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
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
                   TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please title the event';
                    } else if (value.length < 10) {
                      return 'title must be at least 10 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                  EventPicture == null
                      ? Text('No image selected.')
                      : Image.file(EventPicture!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Select Event Picture"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                  onPressed: _submitData,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


