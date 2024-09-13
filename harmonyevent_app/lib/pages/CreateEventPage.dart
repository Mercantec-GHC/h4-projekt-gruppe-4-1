import 'dart:io';
import 'package:flutter/material.dart';
import 'package:harmonyevent_app/models/event_model.dart';
import 'package:status_alert/status_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';
//import 'package:harmonyevent_app/models/event_model.dart';
import 'package:harmonyevent_app/pages/EventPage.dart';
import 'package:harmonyevent_app/services/createevent_service.dart';

class CreateEventPage extends StatefulWidget {
  @override
  CreateEventState createState() {
    return CreateEventState();
  }
}

void showSuccessAlert(BuildContext context) {     
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Success',
    subtitle: 'Event created successfully!', 
    configuration: IconConfiguration(
      icon: Icons.check,
      color: const Color.fromARGB(255, 162, 235, 14),
              size: 180.0,
      ), 
    backgroundColor: Colors.transparent,
    // borderRadius: BorderRadius.circular(10),
  ); 
} 
void showErrorAlert(BuildContext context) { 
  StatusAlert.show( 
    context, 
    duration: Duration(seconds: 2), 
    title: 'Something went wrong', 
    subtitle: 'Please try again!', 
    configuration: IconConfiguration(
      icon: Icons.block_rounded,
      color: const Color.fromARGB(255, 162, 235, 14),
      size: 180.0,
      ), 
    backgroundColor: const Color.fromARGB(255, 36, 51, 6),
  ); 
} 

class CreateEventState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  // final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _placeIdController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _isPrivateController = TextEditingController();

  
  File? EventPicture; // To store the selected image
  
  final picker = ImagePicker(); // Image picker instance
  bool _isLoading = false;

  final CreateEventService _eventService = CreateEventService(); 

    @override
    void dispose() {
    _dateController.dispose();
    _placeIdController.dispose();
    _isPrivateController.dispose();
    _categoryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

// Function to pick an image
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
        _dateController.text = selected.toUtc().toString().split(' ')[0]; // Update date
      });
    }
  }

  // Function to handle form submission
  Future<void> _submitData() async {
  if (_formKey.currentState!.validate()) {
    final String date = _dateController.text;
    final String placeId = _placeIdController.text;
    final String isPrivate = _isPrivateController.text;
    final String title = _titleController.text;
    final String category = _categoryController.text;
    final String description = _descriptionController.text;
    
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
      showSuccessAlert(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EventPage()), // Replace with the correct page
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
        automaticallyImplyLeading: false,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
            // Navigate back to the previous screen by popping the current route
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EventPage()), // Replace with the correct page
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
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              controller: _dateController,
              readOnly: true, 
              decoration: InputDecoration(
                labelText: 'Date',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
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
            //const SizedBox(height: 15),
            ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Pick Event Image'),
              ),
              SizedBox(height: 10),
              EventPicture != null
                  ? Image.file(
                      EventPicture!,
                      height: 150,
                    )
                  : Text('No image selected'),
              //const SizedBox(height: 15),
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
                  return 'Please choose place';
                }
                return null;
              },
            ),
            //const SizedBox(height: 15),
            TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              controller: _placeIdController,
              decoration: InputDecoration(
                labelText: 'Location (PlaceId)',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose place';
                }
                return null;
              },
            ),
            //const SizedBox(height: 15),
            TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              controller: _isPrivateController,
              decoration: InputDecoration(
                labelText: 'Type (IsPrivate)',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'What type';
                }
                return null;
              },
            ),
            //const SizedBox(height: 15),
            TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'What category';
                }
                return null;
              },
            ),
             //const SizedBox(height: 15),
            TextFormField(
              style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              maxLines: 1,
              minLines: 1,
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
                  return 'Describe event';
                }
                return null;
              },
            ),
            //SizedBox(height: 15),
            // TextFormField(         
            //   style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
            //   controller: _userIdController,
            //   decoration: InputDecoration(    
            //     labelText: 'Organized by (UserID)',
            //     labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please choose him';
            //     }
            //     return null;
            //   },
            // ),
            Text(
              "Organized by: ${AutofillHints.username}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 234, 208, 225),
              ),
            ),
            SizedBox(height: 20),
            _isLoading ? Center(child: CircularProgressIndicator()) : GradientButton(
              colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
              height: 40,
              width: 350,
              radius: 20,
              gradientDirection: GradientDirection.leftToRight,
              textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              text: "Create event",
              onPressed: _submitData, 
              ),
            ],
          ),
        ),
      )
    );
  }
}