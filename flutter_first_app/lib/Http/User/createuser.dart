import 'package:flutter_first_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_first_app/config/api_config.dart';




Future<LoginDTO> createUser(String firstname, String lastname, String email, String username, String password, String address, String postal, String city) async {
  final String baseUrl = ApiConfig.apiUrl;
  final response = await http.post(
    Uri.parse('$baseUrl/api/user/signup'),  
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      
      'firstname': firstname,
      'lastname': lastname,
      'email' : email,
      'username': username,
      'password':password,
      'address': address,
      'postal': postal,
      'city': city
    }),
  );
  if (response.statusCode==201){
    return LoginDTO.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

  }
  else {
    
    throw Exception('Failed to create user: ${response.statusCode} - ${response.body}');
  }
  
}


