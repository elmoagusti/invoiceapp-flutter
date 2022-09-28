class TransactionDetail {
  final id;
  final trxid;
  final name;
  final qty;
  final price;
  final total;
  final date;

  TransactionDetail(
      {required this.id,
      required this.trxid,
      required this.name,
      required this.qty,
      required this.price,
      required this.total,
      required this.date});

  static TransactionDetail fromJson(json) => TransactionDetail(
        id: json['id'],
        trxid: json["trxid"],
        name: json['name'],
        qty: json["qty"],
        price: json["price"],
        total: json["total"],
        date: json["date"],
      );

  Map<String, dynamic> transactionDetailMap() => {
        "id": id,
        "trxid": trxid,
        "name": name,
        "qty": qty,
        "price": price,
        "total": total,
        "date": date,
      };
}
