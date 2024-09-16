import 'dart:core';

class EventDTO {
  final String id;
  final String date;
  final String place_id;
  final String EventPicture;
  final String title;
  final String isprivate;
  final String category;
  final String description;

  EventDTO({
    required this.id,
    required this.date,
    required this.place_id,
    required this.EventPicture,
    required this.title,
    required this.isprivate,
    required this.category,
    required this.description,
  });

  // Convert an EventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'place_id': place_id,
      'EventPicture': EventPicture,
      'title': title,
      'isprivate': isprivate,
      'category': category,
      'description': description,
    };
  }

  // Convert a JSON map into an EventDTO object.
  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      place_id: json['place_id'] ?? '',
      EventPicture: json['EventPicture'] ?? '',
      title: json['title'] ?? '',
      isprivate: json['isprivate'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }
}


class CreateEventDTO {
  final DateTime date;
  final String placeId; // Updated to camelCase
  final String eventPicture; // Updated to camelCase
  final String isPrivate; // Updated to camelCase
  final String title;
  final String category;
  final String description;

  CreateEventDTO({
    required this.date,
    required this.placeId,
    required this.eventPicture,
    required this.isPrivate,
    required this.title,
    required this.category,
    required this.description,
  });

  // Convert a CreateEventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'place_id': placeId,
      'EventPicture': eventPicture,
      'isprivate': isPrivate,
      'title': title,
      'category': category,
      'description': description,
    };
  }

  // Convert a JSON map into a CreateEventDTO object.
  factory CreateEventDTO.fromJson(Map<String, dynamic> json) {
    return CreateEventDTO(
      date: DateTime.parse(json['date'] ?? ''),
      placeId: json['place_id'] ?? '',
      eventPicture: json['EventPicture'] ?? '',
      isPrivate: json['isprivate'] ?? '',
      title: json['title'] ?? '', // Fixed incorrect field assignment
      category: json['category'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

