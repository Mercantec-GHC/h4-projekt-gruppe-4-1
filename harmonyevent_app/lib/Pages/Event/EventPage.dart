import 'package:flutter/material.dart';
import 'package:harmonyevent_app/Pages/Event/SeeAllEvents.dart';
import 'package:harmonyevent_app/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:status_alert/status_alert.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';


class CreateEvent extends StatefulWidget {
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
                          showSuccessAlert(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeeAllEvents()), // Replace with the correct page
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
        automaticallyImplyLeading: false,
        leading: IconButton(
        icon: Icon(Icons.arrow_circle_left_outlined),
        onPressed: () {
      // Navigate back to the previous screen by popping the current route
              Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SeeAllEvents()), // Replace with the correct page
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
              controller: dateController,
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
            TextFormField(
               style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              controller: place_idController,
              decoration: InputDecoration(
                labelText: 'Event location',
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

            TextFormField(
               style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              controller: typeController,
              decoration: InputDecoration(
                labelText: 'Event type',
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
            TextFormField(
               style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Event category',
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
            TextFormField(
               style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
                            maxLines: 6,
                minLines: 6,
              controller: descriptionController,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Event description',
                
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
                 SizedBox(height: 20),
                        TextFormField(
                        
               style: TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
   
              controller: user_idController,
              decoration: InputDecoration(
                
                labelText: 'Created by',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 183, 211, 83), fontSize: 16.0),
                                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose him';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _submitData,
            //   child: Text('Submit'),
            // ),
            GradientButton(
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