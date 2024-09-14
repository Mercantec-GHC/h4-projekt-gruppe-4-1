
// model for visning af bruger
class UserDTO{
  final String Id;
  final String Email;
  final String Username;
  final String ProfilePicture;
  
  UserDTO({
    required this.Id,
    required this.Email,
    required this.Username,
    required this.ProfilePicture
  });
   
  Map<String, dynamic> toJson() {
    return {
      'id':Id,
      'email': Email,
      'username': Username,
      'ProfilePicture': ProfilePicture,
    };
  }
  
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
    Id: json['id'] ?? '',
    Email: json['email'] ?? '',
    Username:json['username'] ?? '',
    ProfilePicture: json['ProfilePicture'] ?? '',
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

  // Convert an UserDTO object into a JSON map.
  // Map<String, dynamic> toJson() {
  //   return {
  //     'firstname': firstname,
  //     'lastname': lastname,
  //     'email': email,
  //     'username': username,
  //     'password': password,
  //     'address': address,
  //     'postal': postal,
  //     'city': city,
  //     'profilePicture': profilePicture,
  //   };
  // }

  factory CreateUserDTO.fromJson(Map<String, dynamic> json) {
    return CreateUserDTO(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      address: json['address'] as String,
      postal: json['postal'] as String,
      city: json['city'] as String,
      profilePicture: json['profilePicture'] as String,
    );
  }
}