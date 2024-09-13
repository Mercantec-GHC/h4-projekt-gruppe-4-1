
// import 'dart:io';
// //import 'dart:convert';
// import 'package:http/http.dart' as http;
// //import 'package:http_parser/http_parser.dart'; 
// import 'package:harmonyevent_app/config/api_config.dart';
// //import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// //import 'package:harmonyevent_app/models/event_model.dart';

// class CreateEventService {
//   // Initialize secure storage
//   final FlutterSecureStorage secureStorage = FlutterSecureStorage();

//   // final String _baseUrl = ApiConfig.apiUrl;
//   // Method to create event with image upload
//   //Future<EventDTO> createEvent (
//   Future<void> createEvent (
//     String place_id, 
//     String date,  
//     String category, 
//     String description, 
//     String title, 
//     String isPrivate,
//     File? image
//   ) 
//   async {
//     final String _baseUrl = ApiConfig.apiUrl;
//     var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/event/create'));

//     // // Get the JWT token from shared preferences
//     // final prefs = await SharedPreferences.getInstance();
//     // final token = prefs.getString('token');

//     // // Add authorization header
//     // request.headers['Authorization'] = 'Bearer $token';

//     // Add the form fields
//     request.fields['place_id'] = place_id;
//     request.fields['date'] = date;
//     request.fields['isPrivate'] = isPrivate;
//     request.fields['category'] = category;
//     request.fields['description'] = description;
//     request.fields['title'] = title;

//     // Attach the image file if it's available
//     // if (image != null) {
//     //   var imageStream = http.ByteStream(image.openRead());
//     //   var imageLength = await image.length();
//     //   request.files.add(
//     //     http.MultipartFile(
//     //       'image',
//     //       imageStream,
//     //       imageLength,
//     //       filename: image.path.split('/').last,
//     //     ),
//     //   );
//     // }
//     if (image != null) {
//     request.files.add(
//       http.MultipartFile.fromBytes(
//         'profilePicture',
//         await image.readAsBytes(),
//         filename: image.path.split('/').last,
//         ),
//       );
//     }
//       // Retrieve the token securely
//     final String? token = await secureStorage.read(key: 'token');
//     if (token != null) {
//       request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
//     }

//     try {
//       final response = await request.send();

//       if (response.statusCode == 200) {
//         final responseBody = await response.stream.bytesToString();
//         print("User created successfully: $responseBody");
//       } 
//       else {
//         final responseBody = await response.stream.bytesToString();
//         throw Exception('Failed to create event. Status code: ${response.statusCode}, Response: $responseBody');
//       }
//     } 
//     catch (e) {
//       print("Error: $e");
//       throw Exception('Failed to create event: $e');
//     }
//   }
//   //   var response = await request.send();

//   //   if (response.statusCode == 201) {
//   //     final responseBody = await response.stream.bytesToString();
//   //     return EventDTO.fromJson(jsonDecode(responseBody));
//   //   } else {
//   //     final responseBody = await response.stream.bytesToString();
//   //     throw Exception('Failed to create event: ${response.statusCode}, Response: $responseBody');
//   //   }
//   // }
// }