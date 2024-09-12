
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; 
import 'package:harmonyevent_app/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:harmonyevent_app/models/user.dart';

class CreateUserService {
  final String _baseUrl = ApiConfig.apiUrl;
  // Method to create event with image upload
  Future<CreateUserDTO> createUser(
      String firstname,
      String lastname,
      String email,
      String username,
      String password,
      String address,
      String postal,
      String city,
      File? image
    ) async {
    var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/api/user/signup'));

    // Get the JWT token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Add authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Add the form fields
    request.fields['firstname'] = firstname;
    request.fields['lastname'] = lastname;
    request.fields['email'] = email;
    request.fields['username'] = username;
    request.fields['password'] = password;
    request.fields['address'] = address;
    request.fields['postal'] = postal;
    request.fields['city'] = city;

    // Attach the image file if it's available
    // if (image != null) {
    //   var imageStream = http.ByteStream(image.openRead());
    //   var imageLength = await image.length();
    //   request.files.add(
    //     http.MultipartFile(
    //       'image',
    //       imageStream,
    //       imageLength,
    //       filename: image.path.split('/').last,
    //     ),
    //   );
    // }
    // Attach the image file if it's available
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'ProfilePicture', 
        image.path,
        contentType: MediaType('image', 'png'),
      ));
    }

    request.headers.addAll({
      'accept': '*/*',
      'Content-Type': 'multipart/form-data',
    });
    
    var response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return CreateUserDTO.fromJson(jsonDecode(responseBody) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create user: ${response.statusCode}'); 
    }
  }
}