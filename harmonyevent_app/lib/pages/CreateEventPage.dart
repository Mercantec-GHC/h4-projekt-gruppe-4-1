
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

import 'package:harmonyevent_app/components/custom_limitedappbar.dart';
import 'package:harmonyevent_app/components/custom_alerts.dart';
import 'package:harmonyevent_app/models/event_model.dart';
import 'package:harmonyevent_app/services/createevent_service.dart';
import 'package:harmonyevent_app/pages/EventPage.dart';

class CreateEventPage extends StatefulWidget {
  @override
  CreateEventState createState() {
    return CreateEventState();
  }
}

class CreateEventState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  File? EventPicture; // To store the selected image
  final picker = ImagePicker(); // Image picker instance
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _isPrivateController = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<FormFieldState> _isPrivateFieldKey = GlobalKey();

  final CreateEventService _eventService = CreateEventService(); 

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _isPrivateController.dispose();
    super.dispose();
  }

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

  //  SwitchListTile standard selection
  bool SwitchIsChecked = false; 

  // Function to handle form submission
  Future<void> _submitData() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;      
    });


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
    final String date = _dateController.text;
    final String location = _locationController.text;
    final String title = _titleController.text;
    final String category = _categoryController.text;
    final String description = _descriptionController.text;
    final String isPrivate = _isPrivateController.text;
    
    try {
      // Call EventService to create the event
      final CreateEventDTO newEventDTO = await _eventService.createEvent(
        eventPicture, 
        date,
        location,
        category,
        title,
        description,
        isPrivate,
      );
      showSuccessAlertCreateEvent(context);
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
    } 
    catch (e) {
      showErrorAlertCreateEvent(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create event: $e"),
        ),
      );
    }
    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //GET CUSTOM LIMITED APPBAR FROM /components/custom_limitedappbar.dart
      appBar: CustomLimitedAppBar(),

      //FORM FIELD
      body: Padding(
      padding: const EdgeInsets.all(66.0),
      child: Form(
        key: _formKey,
        
        child: Column(

          //FORM FIELD CHIRLDEREN
          children: [

            //SELECT IMAGE
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(
                Icons.image,
                color: const Color.fromARGB(255, 183, 211, 83),),
                label: Text('Choose image'),              
            ),
            SizedBox(height: 10),
            EventPicture != null ? Image.file(
              EventPicture!,
              height: 100,
            )
            : Text(
              'Prefered size 500x281 pixels',
              style: TextStyle(
                 color: const Color.fromARGB(255, 183, 211, 83)
                ),),
            SizedBox(height: 15),

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
            const SizedBox(height: 25),

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
            //const SizedBox(height: 15),

            // SELECT CATEGORY
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
                  return 'Please choose category';
                }
                return null;
              },
            ),
            //const SizedBox(height: 15),

            // WRITE DESCRIPTION
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
                  return 'Please make decription';
                }
                return null;
              },
            ),
              
            //EVENT IS PRIVATE BOOL
            FormField(
              key: _isPrivateFieldKey,
              initialValue: false,
              validator: (value) {
                if (value == null) return 'Please select if event is private';
                return null;
              },
              builder: (FormFieldState<bool> field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ), // labelText: 'Subscribe to mailing list.',
                  errorText: field.errorText,
                  ),
                  child: SwitchListTile(
                    hoverColor: const Color.fromARGB(255, 36, 51, 6),
                    activeColor: Color.fromARGB(255, 234, 208, 225),
                    inactiveThumbColor: Color.fromARGB(255, 234, 208, 225),
                    activeTrackColor: const Color.fromARGB(255, 183, 211, 83),
                    inactiveTrackColor: const Color.fromARGB(255, 234, 208, 225),
                    title: const Text(
                      "Private",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 183, 211, 83)
                    ),
                    selectionColor: const Color.fromARGB(255, 183, 211, 83),
                    ),
                    secondary: const SizedBox(
                      child: Icon(
                        Icons.lock,
                        color: const Color.fromARGB(255, 183, 211, 83),
                        size: 25,
                      ),
                    ),
                    value: SwitchIsChecked,         
                    onChanged: (value) {
                      setState(() {
                        SwitchIsChecked = value;
                        _isPrivateController.text = value.toString();
                        print(value);
                        });            
                      },
                    ),
                  );
                },
              ),

              //ORGANIZED BY
              TextFormField(
                style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                //controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Organized by',
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
              const SizedBox(height: 25),       

              //CREATE EVENT BUTTON
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



