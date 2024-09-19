class EventDTO {
  final String id;
  final String date;
  final String eventPicture;
  final String place_id;
  final String title;
  final String category;
  final String description;
  final String isprivate;
  final String eventCreator_id;
  final List<dynamic> participants; // New field for participants

  EventDTO({
    required this.id,
    required this.eventPicture,
    required this.date,
    required this.place_id,
    required this.title,
    required this.category,
    required this.description,
    required this.isprivate,
    required this.eventCreator_id,
    required this.participants, // Initialize the new field
  });

  // Convert an EventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'eventPicture': eventPicture,
      'place_id': place_id,
      'title': title,
      'category': category,
      'description': description,
      'isprivate': isprivate,
      'eventCreator_id': eventCreator_id,
      'participants': participants, // Include participants
    };
  }

  // Convert a JSON map into an EventDTO object.
  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      id: json['id'] ?? '',
      eventPicture: json['eventPicture'] ?? '',
      date: json['date'] ?? '',
      place_id: json['place_id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      isprivate: json['isprivate'] ?? '',
      eventCreator_id: json['eventCreator_id'] ?? '',
      participants: json['participants'] ?? [], // Handle missing participants
    );
  }
}


class CreateEventDTO {
  final String eventPicture; // Updated to camelCase
  final String date;
  final String placeId; // Updated to camelCase
  final String title;
  final String category;
  final String description;
  final String isPrivate; // Updated to camelCase

  CreateEventDTO({
    required this.eventPicture,
    required this.date,
    required this.placeId,
    required this.title,
    required this.category,
    required this.description,
    required this.isPrivate,
  });

  // Convert a CreateEventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'eventPicture': eventPicture,
      'date': date,
      'place_id': placeId,
      'title': title,
      'category': category,
      'description': description,
      'isprivate': isPrivate,
    };
  }

  // Convert a JSON map into a CreateEventDTO object.
  factory CreateEventDTO.fromJson(Map<String, dynamic> json) {
    return CreateEventDTO(
      eventPicture: json['eventPicture'] ?? '',
      date: json['date'] ?? '',
      placeId: json['place_id'] ?? '',
      title: json['title'] ?? '', // Fixed incorrect field assignment
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      isPrivate: json['isprivate'] ?? '',
    );
  }
}

class UpdateEventDTO {
  final String id;
  final String date;
  final String place_id;
  final String description;
  final String title;
  final String eventPicture;
  final String category;
  final String isprivate;
  final List<dynamic> participants;

  UpdateEventDTO({
    required this.id,
    required this.date,
    required this.place_id,
    required this.description,
    required this.title,
    required this.eventPicture,
    required this.category,
    required this.isprivate,
    required this.participants,
  });

  factory UpdateEventDTO.fromJson(Map<String, dynamic> json) {
    return UpdateEventDTO(
      id: json['id'],
      date: json['date'],
      place_id: json['place_id'],
      description: json['description'],
      title: json['title'],
      eventPicture: json['eventPicture'],
      category: json['category'],
      isprivate: json['isprivate'],
      participants: json['participants'] ?? [],
    );
  }
}