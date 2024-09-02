class LoginDTO {
  final String email;
  final String password;

  LoginDTO({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginDTO.fromJson(Map<String, dynamic> json) {
    return LoginDTO(
    email: json['email'] as String,
    password: json['password'] as String,
    );
  }

  get username => null;
}