class Cart {
  int? id;
  String? name;
  String? noinvoice;
  double? price;
  int? qty;
  double? total;

  cartMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['noinvoice'] = noinvoice;
    mapping['price'] = price;
    mapping['qty'] = qty;
    mapping['total'] = total;
    return mapping;
  }
}
