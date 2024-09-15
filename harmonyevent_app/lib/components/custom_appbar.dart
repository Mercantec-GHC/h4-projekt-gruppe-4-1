
import 'package:flutter/material.dart';

import 'package:harmonyevent_app/pages/CreateEventPage.dart';
import 'package:harmonyevent_app/pages/UserProfilePage.dart';
import 'package:harmonyevent_app/pages/EventPage.dart';

class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  const customAppBar({
    super.key,
  });

  Size get PreferredSize => Size.fromHeight(kToolbarHeight);
  
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
          onPressed: () {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateEventPage()), // Replace with the correct page
            );
          }
        ),
        //PLANNED EVENTS
        IconButton(
          icon: const Icon(
            Icons.event_available, 
            color: Color.fromARGB(255, 183, 211, 54)
            ),
          tooltip: "Planned Events",
          onPressed: () {
            print("Hmm");
          }
        ),
    
        //USER PROFILE
        IconButton(
          icon: const Icon(
            Icons.manage_accounts_sharp, 
            color: Color.fromARGB(255, 183, 211, 54),
            size: 26
          ),
          tooltip: "Your account",
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
  Size get preferredSize => Size.fromHeight(80.0);
}