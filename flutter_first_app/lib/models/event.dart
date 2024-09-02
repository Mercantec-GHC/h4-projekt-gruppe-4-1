import 'dart:core';

class EventDTO {
 
  final String user_id;
  final DateTime dateTime;
  final String place_id;
  final String ImageURL;
  final String type;
  final String category;
  final String description;
  

 


  EventDTO({
    required this.user_id,
    required this.dateTime,
    required this.place_id,
    required this.ImageURL,
    required this.type,
    required this.category,
    required this.description,
    

  });

  // Convert an Event object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'User_id' : user_id,
      'dateTime' : dateTime,
      'place_id': place_id,
      'ImageURL': ImageURL,
      'type': type,
      'category': category,
      'description': description,
     
      
    };
  }


  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      user_id: json['User_id'] as String,
      dateTime: DateTime(2024),
      place_id: json['place_id'] as String,
      ImageURL: json['ImageURL'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      
     
    );
  }
}