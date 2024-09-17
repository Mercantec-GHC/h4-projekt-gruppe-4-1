
import 'package:flutter/material.dart';

import 'package:harmonyevent_app/pages/event/CreateEventPage.dart';
import 'package:harmonyevent_app/pages/user/UserProfilePage.dart';
import 'package:harmonyevent_app/pages/event/EventPage.dart';
import 'package:harmonyevent_app/pages/event/MyEventPage.dart';
import 'package:harmonyevent_app/services/login_service.dart';


class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthService _authService = AuthService();
  final dynamic actions;
  
  CustomMainAppBar({
    this.actions,
    super.key,
  });
  
  @override
  
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[
        
        //SEARCH EVENTS
        IconButton(
          icon: const Icon(
            Icons.search, 
            color: Color.fromARGB(255, 183, 211, 54),
                       size: 26,
            ),
          tooltip: "Search Events",
          onPressed: () {
            print("Hmm");
          }
        ),
        
        //ALL EVENTS
        IconButton(
          icon: Icon(
            Icons.event, 
            color: const Color.fromARGB(255, 183, 211, 54),
            // color: const Color.fromARGB(255, 234, 208, 225),
          ),
          tooltip: "All Events",
          onPressed: () {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EventPage()), // Replace with the correct page
            );
          }
        ),

        //CREATE EVENT
        IconButton(
          icon: Icon(
            Icons.library_add_outlined, 
            color: const Color.fromARGB(255, 183, 211, 54),
          ),
          tooltip: "Create Event",
          onPressed: () async {
                  final token = await _authService.getToken();
                  print('Token retrieved: $token'); // Debugging statement
                  if (token != null && !_authService.isTokenExpired(token)) {
                  Navigator.push(
                    context,                      
                    MaterialPageRoute(
                      builder: (context) => CreateEventPage()),
                    );
                  } 
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not logged in or token expired')),
                    );
                  }
                }
              ),

        //MY EVENTS
        IconButton(
          icon: const Icon(
            Icons.event_available, 
            color: Color.fromARGB(255, 183, 211, 54)
            ),
          tooltip: "My Events",
          onPressed: () async {
                  final token = await _authService.getToken();
                  print('Token retrieved: $token'); // Debugging statement
                  if (token != null && !_authService.isTokenExpired(token)) {
                  Navigator.push(
                    context,                      
                    MaterialPageRoute(
                      builder: (context) => MyEventsPage()),
                    );
                  } 
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not logged in or token expired')),
                    );
                  }
                }
              ),
    
        //USER PROFILE
        IconButton(
          icon: const Icon(
            Icons.manage_accounts_sharp, 
            color: Color.fromARGB(255, 183, 211, 54),
            size: 26
          ),
          tooltip: "My Profile",
          onPressed: () {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserProfilePage()), // Replace with the correct page
            );
          }
        ),
      ],
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
    );
  }  
  @override
  Size get preferredSize => Size.fromHeight(60.0);
}

