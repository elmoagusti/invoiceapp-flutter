class Transactions {
  final id;
  final noinvoice;
  final name;
  final tax;
  final subtotal;
  final discount;
  final nettotal;
  final date;
  final type;
  final typeName;
  final money;
  final change;

  Transactions(
      {required this.id,
      required this.noinvoice,
      required this.name,
      required this.tax,
      required this.subtotal,
      required this.discount,
      required this.nettotal,
      required this.date,
      required this.type,
      required this.typeName,
      required this.money,
      required this.change});

  static Transactions fromJson(json) => Transactions(
      id: json['id'],
      noinvoice: json['noinvoice'],
      name: json['name'],
      tax: json['tax'],
      subtotal: json['subtotal'],
      discount: json['discount'],
      nettotal: json['nettotal'],
      date: json["date"],
      type: json['type'],
      typeName: json['typename'],
      money: json['money'],
      change: json["change"]);

  Map<String, dynamic> transactionsMap() => {
        "id": id,
        "noinvoice": noinvoice,
        "name": name,
        "tax": tax,
        "subtotal": subtotal,
        "discount": discount,
        "nettotal": nettotal,
        "date": date,
        "type": type,
        "typename": typeName,
        "money": money,
        "change": change,
      };
}
