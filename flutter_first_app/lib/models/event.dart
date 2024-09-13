import 'dart:core';

class EventDTO {
  final String date;
  final String place_id;
  final String EventPicture;
  final String isprivate;
  final String category;
  final String description;

  EventDTO({
    required this.date,
    required this.place_id,
    required this.EventPicture,
    required this.isprivate,
    required this.category,
    required this.description,
  });

  // Convert an EventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'date': date,  
      'place_id': place_id,
      'EventPicture': EventPicture,
      'isprivate': isprivate,
      'category': category,
      'description': description,
    };
  }

  // Convert a JSON map into an EventDTO object.
factory EventDTO.fromJson(Map<String, dynamic> json) {
  return EventDTO(
    date: json['date'] ?? '',
    place_id: json['place_id'] ?? '',
    EventPicture: json['EventPicture'] ?? '',
    isprivate: json['isprivate'] ??'', 
    category: json['category'] ?? '',
    description: json['description'] ?? '',
  );
}}

class CreateEventDTO {
  final DateTime date;
  final String place_id;
  final String EventPicture;
  final String isprivate;
  final String title;
  final String category;
  final String description;
  

  CreateEventDTO({
    required this.date,
    required this.place_id,
    required this.EventPicture,
    required this.isprivate,
    required this.title,
    required this.category,
    required this.description,
    
  });

  // Convert an EventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),  
      'place_id': place_id,
      'EventPicture': EventPicture,
      'isprivate': isprivate,  
      'title': title,  
      'category': category,
      'description': description,
    };
  }

  // Convert a JSON map into a CreateEventDTO object.
  factory CreateEventDTO.fromJson(Map<String, dynamic> json) {
    return CreateEventDTO(
      date: DateTime.parse(json['date'] ?? ''),
      place_id: json['place_id'] ?? '',
      EventPicture: json['EventPicture'] ?? '',
      isprivate: json['isprivate'] ?? '',  
      title: json['isprivate'] ?? '',  
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

