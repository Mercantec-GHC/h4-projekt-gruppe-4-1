import 'dart:core';

class EventDTO {
 
  
  final DateTime date;
  final String place_id;
  final String ImageURL;
  final String type;
  final String category;
  final String description;
  

 


  EventDTO({
    
    required this.date,
    required this.place_id,
    required this.ImageURL,
    required this.type,
    required this.category,
    required this.description,
    

  });

  // Convert an Event object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      
      'date' : date,
      'place_id': place_id,
      'ImageURL': ImageURL,
      'type': type,
      'category': category,
      'description': description,
     
      
    };
  }


  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      
      date: DateTime(2024),
      place_id: json['place_id'] as String,
      ImageURL: json['ImageURL'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      
     
    );
  }
}