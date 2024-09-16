
class EventDTO {
  final String id;
  final String eventPicture;
  final String date;
  final String location;
  final String title;
  final String category;
  final String description;
  final String isprivate;

  EventDTO({
    required this.id,
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
      'id': id,  
      'eventPicture': eventPicture,
      'date': date,  
      'location': location,
      'title': title,
      'category': category,
      'description': description,
      'isprivate': isprivate,
    };
  }

// Convert a JSON map into an EventDTO object.
factory EventDTO.fromJson(Map<String, dynamic> json) {
  return EventDTO(
    id: json['id'] ?? '',
    eventPicture: json['imageURL'] ?? '',
    date: json['date'] ?? '',
    location: json['location'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? '',
    description: json['description'] ?? '',
    isprivate: json['isprivate'] ??'', 
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
      location: json['location'] ?? '', 
      title: json['title'] ?? '',  
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      isprivate: json['isprivate'] ?? '', 
    );
  }
}

