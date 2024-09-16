import 'dart:io';
import 'package:flutter_first_app/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();

// Function to create a user
Future<void> createUser(
  String firstName,
  String lastName,
  String email,
  String username,
  String password,
  String address,
  String postal,
  String city,
  File? image,
) async {
  const String baseUrl = ApiConfig.apiUrl;
  final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/User/SignUp'));

  
  request.fields['firstname'] = firstName;
  request.fields['lastname'] = lastName;
  request.fields['email'] = email;
  request.fields['username'] = username;
  request.fields['password'] = password;
  request.fields['address'] = address;
  request.fields['postal'] = postal;
  request.fields['city'] = city;

  if (image != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'profilePicture',
        await image.readAsBytes(),
        filename: image.path.split('/').last,
      ),
    );
  }

  
  final String? token = await secureStorage.read(key: 'token');
  if (token != null) {
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  }

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("User created successfully: $responseBody");
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to create user. Status code: ${response.statusCode}, Response: $responseBody');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to create user: $e');
  }
}


Future<void> updateUser(
  String userId,
  String firstName,
  String lastName,
  String email,
  String username,
  String address,
  String postal,
  String city,
  File? image,
) async {
  const String baseUrl = ApiConfig.apiUrl;
  final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/api/User/Update/$userId'));

  
  request.fields['firstname'] = firstName;
  request.fields['lastname'] = lastName;
  request.fields['email'] = email;
  request.fields['username'] = username;
  request.fields['address'] = address;
  request.fields['postal'] = postal;
  request.fields['city'] = city;

  if (image != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'profilePicture',
        await image.readAsBytes(),
        filename: image.path.split('/').last,
      ),
    );
  }

  
  final String? token = await secureStorage.read(key: 'token');
  if (token != null) {
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
  }

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("User updated successfully: $responseBody");
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to update user. Status code: ${response.statusCode}, Response: $responseBody');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to update user: $e');
  }
}


Future<void> deleteUser(String userId) async {
  const String baseUrl = ApiConfig.apiUrl;

  
  final String? token = await secureStorage.read(key: 'token');
  if (token == null) {
    throw Exception('No authorization token found.');
  }

  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/User/Delete/$userId'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("User deleted successfully.");
    } else {
      throw Exception('Failed to delete user. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to delete user: $e');
  }
}
