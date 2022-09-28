class Carts {
  final int id;
  final String name;
  final double price;
  final int qty;
  final double total;

  Carts({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.total,
  });

  static Carts fromJson(json) => Carts(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        qty: json['qty'],
        total: json['total'],
      );

  Map<String, dynamic> cartsMap() => {
        "id": id,
        "name": name,
        "price": price,
        "qty": qty,
        "total": total,
      };
}
