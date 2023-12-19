class ConsoleModel {
  final String id;
  final String name;
  // ignore: non_constant_identifier_names
  final String brand_id;
  final String year;
  final String price;
  final String description;
  final String image;
  final int stock;
  // ignore: non_constant_identifier_names
  final int total_sales;
  // ignore: non_constant_identifier_names
  final String created_at;
  // ignore: non_constant_identifier_names
  final String updated_at;

  ConsoleModel(
      {required this.id,
      required this.name,
      // ignore: non_constant_identifier_names
      required this.brand_id,
      required this.year,
      required this.price,
      required this.description,
      required this.image,
      required this.stock,
      // ignore: non_constant_identifier_names
      required this.total_sales,
      // ignore: non_constant_identifier_names
      required this.created_at,
      // ignore: non_constant_identifier_names
      required this.updated_at});

  factory ConsoleModel.fromJson(Map<String, dynamic> json) {
    return ConsoleModel(
      id: json['id'].toString(),
      name: json['name'],
      brand_id: json['brand_id'].toString(),
      year: json['year'].toString(),
      price: json['price'].toString(),
      description: json['description'],
      image: json['image'],
      stock: json['stock'],
      total_sales: json['total_sales'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand_id': brand_id,
        'year': year,
        'price': price,
        'description': description,
        'image': image,
        'stock': stock,
        'total_sales': total_sales,
        'created_at': created_at,
        'updated_at': updated_at,
      };
}
