class Categories {
  final id;
  final name;

  Categories({
    required this.id,
    required this.name,
  });

  static Categories fromJson(json) => Categories(
        id: json['categories_id'],
        name: json['categories_name'],
      );

  Map<String, dynamic> categoriesMap() => {
        "categories_id": id,
        "categories_name": name,
      };
}
