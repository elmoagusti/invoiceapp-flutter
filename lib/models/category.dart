class Category {
  int? id;
  String? name;

  Map<String, dynamic> categoryMap() => {
        "id": id,
        "name": name,
      };
}
