class Product {
  int? id;
  String? name;
  String? category;
  double? price;

  productMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['category'] = category;
    mapping['price'] = price;

    return mapping;
  }
}
