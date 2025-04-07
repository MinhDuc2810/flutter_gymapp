class User {
  final String id;
  final String email;
  final String username;
  final String phoneNumber;
  final String birthday;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.birthday,
    required this.role,
  });

  // Constructor từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phonenumber'],
      birthday: json['birthday'],
      role: json['role'],
    );
  }
}
