
// model for visning af bruger
class UserDTO{
  final String id;
  final String email;
  final String username;
  final String profilePicture;
  
  UserDTO({
    required this.id,
    required this.email,
    required this.username,
    required this.profilePicture
  });
   
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profilePicture': profilePicture,
    };
  }
  
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
    id: json['id'] ?? '',
    email: json['email'] ?? '',
    username: json['username'] ?? '',
    profilePicture: json['profilePicture'] ?? '',
    );
  }
}

// model for oprettelse af bruger
class CreateUserDTO {
  final String firstname;
  final String lastname;
  final String email;
  final String username;
  final String password;
  final String address;
  final String postal;
  final String city;
  final String profilePicture;

  CreateUserDTO({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.username,
    required this.password,
    required this.address,
    required this.postal,
    required this.city,
    required this.profilePicture,
  });

  //Convert an UserDTO object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'username': username,
      'password': password,
      'address': address,
      'postal': postal,
      'city': city,
      'profilePicture': profilePicture,
    };
  }

  factory CreateUserDTO.fromJson(Map<String, dynamic> json) {
    return CreateUserDTO(
      firstname: json['firstname'] ?? '',
      lastname: json['firstname'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      address: json['address'] ?? '',
      postal: json['postal'] ?? '',
      city: json['city'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }
}