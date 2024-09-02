import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String title;

  User({required this.title});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      title: json['title'],
    );
  }
}

Future<User> updateuser(String title) async {
  final response = await http.put(
    Uri.parse("https://your-backend-url.com/updateUser"),  // Replace with your actual backend URL
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    
    return User.fromJson(jsonDecode(response.body));
  } else {
    
    throw Exception('Failed to update user');
  }
}
