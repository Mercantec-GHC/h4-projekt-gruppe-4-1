
import 'package:flutter/material.dart';

import 'package:harmonyevent_app/components/custom_mainappbar.dart';
import 'package:harmonyevent_app/models/user_model.dart';
import 'package:harmonyevent_app/pages/user/UpdateUserPage.dart';
import 'package:harmonyevent_app/pages/user/DeleteUserPage.dart';
import 'package:harmonyevent_app/services/fetch_service.dart';
import 'package:flutter_gradient_button/flutter_gradient_button.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}
class _UserProfilePageState extends State<UserProfilePage> {
  late Future<List<UserDTO>> usersFuture;

  @override
  void initState() {
    super.initState();
    usersFuture = fetchUsers(); // Fetch users in initState
  }

 Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMainAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Center(
          child: Column(
          children: [
            
            Container(
                      //width: 150,
                      child: Column(
                        children: [
                          Text(
                            "RayTheMan",
                            style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 183, 211, 83),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 183, 211, 83),
                              radius: 40,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: ClipOval (
                                  child: Image.network(
                                    "https://eventharmoni.mercantec.tech/eventharmoni/PPc0c029f2f1fc462eadaf7178f6c6dd74.png",                             
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 300); // Handle broken images
                                    },
                                  ), 
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

            GradientButton(
               colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
               height: 40,
               width: 350,
               radius: 20,
               gradientDirection: GradientDirection.leftToRight,
               textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
               text: "Update profile",
                 onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => UpdateUserPage(),
                   ),  
                 );
               },
            ),
            SizedBox(height: 20),
            GradientButton(
               colors: [const Color.fromARGB(255, 183, 211, 54), const Color.fromARGB(255, 109, 190, 66)],
               height: 40,
               width: 350,
               radius: 20,
               gradientDirection: GradientDirection.leftToRight,
               textStyle:  TextStyle(color: Color.fromARGB(255, 234, 208, 225)),
               text: "Delete profile",
                 onPressed: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => DeleteUserPage(),
                   ),  
                 );
               },
            ),
          ],
                ),
        ),
      ),
    );  
  }
}