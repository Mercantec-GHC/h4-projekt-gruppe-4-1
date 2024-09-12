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

  // Convert an EventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),  // Serializes DateTime to a String in ISO format
      'place_id': place_id,
      'ImageURL': ImageURL,
      'type': type,
      'category': category,
      'description': description,
    };
  }

  // Convert a JSON map into an EventDTO object.
  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      date: DateTime.parse(json['date'] ??'' ),
      place_id: json['place_id'] ?? '',
      ImageURL: json['ImageURL'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ??'',
      description: json['description'] ??'' ,
    );
  }
}