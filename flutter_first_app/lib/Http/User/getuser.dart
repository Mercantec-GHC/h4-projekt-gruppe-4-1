import 'dart:convert';
import 'dart:io';
import 'package:flutter_first_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_first_app/config/api_config.dart';

// hent bruger
Future<LoginDTO>fetchuser() async{
  final String baseUrl = ApiConfig.apiUrl;
  final response = await http.get(Uri.parse('$baseUrl/api/user'),
  headers:{
HttpHeaders.authorizationHeader: '',
  
  },
  );
  if (response.statusCode==200){
    return LoginDTO.fromJson(jsonDecode(response.body)as Map<String, dynamic>);

  }else{
    throw Exception('failed');
  }
}

