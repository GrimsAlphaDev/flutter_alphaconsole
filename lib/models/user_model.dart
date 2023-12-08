class UserModel {
  final String id;
  final String username;
  final String email;
  final String image;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']
          .toString(), // Assuming 'id' is a numeric value in the response
      username: json['username'],
      email: json['email'],
      image: json['image'],
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'image': image,
      };
}
