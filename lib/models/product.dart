
class Products {
  final id;
  final name;
  final category;
  final categoriesname;
  final price;

  Products(
      {required this.id,
      required this.name,
      required this.category,
      required this.categoriesname,
      required this.price});

  static Products fromJson(json) => Products(
        id: json['id'],
        name: json['name'],
        category: json["category"],
        categoriesname: json["categories_name"],
        price: json["price"],
      );

  Map<String, dynamic> productsMap() => {
        "id": id,
        "name": name,
        "category": category,
        "price": price,
      };
}
