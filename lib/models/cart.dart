class Cart {
  int? id;
  String? name;
  String? noinvoice;
  double? price;
  int? qty;
  double? total;

  Map<String, dynamic> cartMap() => {
        "id": id,
        "name": name,
        "noinvoice": noinvoice,
        "price": price,
        "qty": qty,
        "total": total,
      };
}
