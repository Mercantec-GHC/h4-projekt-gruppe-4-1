
import 'package:flutter/material.dart';
import 'package:harmonyevent_app/pages/event/EventPage.dart';

class CustomLimitedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomLimitedAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Color.fromARGB(255, 234, 208, 225)),
          onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EventPage()),
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
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(60.0);
}