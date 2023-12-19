class BrandModel {
  final String id;
  final String name;

  BrandModel({
    required this.id,
    required this.name,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']
          .toString(), // Assuming 'id' is a numeric value in the response
      name: json['name'],
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
