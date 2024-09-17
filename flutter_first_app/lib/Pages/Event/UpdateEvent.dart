import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_first_app/services/event_service.dart'; // Assuming EventService is in this path
import 'package:flutter_first_app/models/event.dart'; // Assuming EventDTO and UpdateEventDTO are in this path

class UpdateEventPage extends StatefulWidget {
  final String eventId; // Event ID to update
  final EventDTO eventDetails; // Pass the current event details to populate the form

  const UpdateEventPage({
    super.key,
    required this.eventId,
    required this.eventDetails,
  });

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  DateTime _selectedDate = DateTime.now();
  bool _isPrivate = false;
  File? _eventPicture;

  @override
  void initState() {
    super.initState();
    // Initialize the form controllers with the current event details
    _titleController = TextEditingController(text: widget.eventDetails.title);
    _descriptionController = TextEditingController(text: widget.eventDetails.description);
    _categoryController = TextEditingController(text: widget.eventDetails.category);
    _selectedDate = DateTime.parse(widget.eventDetails.date);
    _isPrivate = widget.eventDetails.isprivate == 'true'; // Convert string to bool
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Method to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _eventPicture = File(pickedFile.path);
      });
    }
  }

  // Method to update the event
  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Convert date to a string in ISO format
        String formattedDate = _selectedDate.toIso8601String();
        
        // Call updateEventById method from EventService
        await EventService().updateEventById(
          widget.eventId,                // Event ID
          formattedDate,                  // Event date
          widget.eventDetails.place_id,   // Place ID (not changing)
          _titleController.text,          // Updated title
          _descriptionController.text,    // Updated description
          _categoryController.text,       // Updated category
          _isPrivate,                     // Updated privacy status
          eventPicture: _eventPicture,    // Updated event picture (if selected)
        );

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event updated successfully!')),
        );
        Navigator.pop(context); // Go back to the previous page
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update event: $e')),
        );
      }
    }
  }

  // Method to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Private Event'),
                value: _isPrivate,
                onChanged: (bool value) {
                  setState(() {
                    _isPrivate = value;
                  });
                },
              ),
              SizedBox(height: 16),
              _eventPicture == null
                  ? Text('No image selected.')
                  : Image.file(
                      _eventPicture!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Event Picture'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateEvent,
                child: Text('Update Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
