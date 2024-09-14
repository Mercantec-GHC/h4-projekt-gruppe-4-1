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
  final TextEditingController timeController = TextEditingController(); 
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
    timeController.dispose(); 
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
        dateController.text = selected.toUtc().toString().split(' ')[0]; 
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
        timeController.text = selected.format(context); 
      });
    }
  }

  
  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final String date = dateController.text;
      final String time = timeController.text; 
      final String placeId = placeIdController.text;
      final String isPrivate = isPrivateController.text;
      final String title = titleController.text;
      final String category = categoryController.text;
      final String description = descriptionController.text;
      
      File? eventPicture; 

      
      if (EventPicture != null) {
        eventPicture = EventPicture; 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select an event picture."),
          ),
        );
        return;
      }

      try {
        
        final CreateEventDTO newEventDTO = await _eventService.createEvent(
          placeId,
          "$date $time", 
          category,
          isPrivate,
          title,
          description,
          eventPicture, 
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Event '${newEventDTO.title}' created successfully."),
          ),
        );

        
        _formKey.currentState?.reset();
        setState(() {
          EventPicture = null; 
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
                // Date field
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
                
                // Time field
                TextFormField(
                  controller: timeController,
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
                  controller: placeIdController,
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
                  value: isPrivateController.text.isNotEmpty ? isPrivateController.text : null,
                  decoration: InputDecoration(labelText: 'Private/Public'),
                  items: [
                    DropdownMenuItem(value: 'true', child: Text('Private')),
                    DropdownMenuItem(value: 'false', child: Text('Public')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isPrivateController.text = value!;  
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
                  controller: categoryController,
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

                // Title field
                TextFormField(
                  controller: titleController,
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
                EventPicture == null
                    ? Text('No image selected.')
                    : Image.file(EventPicture!),
                const SizedBox(height: 16),
                
                // Select Event Picture button
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Select Event Picture"),
                ),
                const SizedBox(height: 16),
                
                // Submit button
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
