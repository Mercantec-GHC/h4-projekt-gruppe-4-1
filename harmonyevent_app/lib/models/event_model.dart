
class EventDTO {
  final String id;
  final String eventPicture;
  final String date;
  final String location;
  final String title;
  final String category;
  
  final String description;
  final String isprivate;
  final String eventCreator_id;

  EventDTO({
    required this.id,
    required this.eventPicture,
    required this.date,
    required this.location,
    required this.title,
    required this.category,
    required this.description,
    required this.isprivate,
    required this.eventCreator_id
  });

  // Convert an EventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'eventPicture': eventPicture,
      'date': date,  
      'location': location,
      'title': title,
      'category': category,
      'description': description,
      'isprivate': isprivate,
      'eventCreator_id': eventCreator_id,
    };
  }

// Convert a JSON map into an EventDTO object.
factory EventDTO.fromJson(Map<String, dynamic> json) {
  return EventDTO(
    id: json['id'] ?? '',
    eventPicture: json['imageURL'] ?? '',
    date: json['date'] ?? '',
    location: json['place_id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    description: json['description'] ?? '',
    isprivate: json['isprivate'] ??'', 
    eventCreator_id: json['eventCreator_id']
  );
}}

class CreateEventDTO {
  final String eventPicture;
  final String date;
  final String location;
  final String title;
  final String category;
  final String description;
  final String isprivate;
  
  CreateEventDTO({
    required this.eventPicture,
    required this.date,
    required this.location,
    required this.title,
    required this.category,
    required this.description,
    required this.isprivate,
  });

  // Convert an EventDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'eventPicture': eventPicture,
      'date': date,  
      'location': location,
      'title': title,  
      'category': category,
      'description': description,
      'isprivate': isprivate,  
    };
  }

  // Convert a JSON map into a CreateEventDTO object.
  factory CreateEventDTO.fromJson(Map<String, dynamic> json) {
    return CreateEventDTO(
      eventPicture: json['imageURL'] ?? '',
      date: json['date'] ?? '',
      location: json['place_id'] ?? '', 
      title: json['title'] ?? '',  
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      isprivate: json['isprivate'] ?? '', 
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
