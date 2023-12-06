class UserModel {
  final String id;
  final String username;
  final String email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']
          .toString(), // Assuming 'id' is a numeric value in the response
      username: json['username'],
      email: json['email'],
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
      };
}
