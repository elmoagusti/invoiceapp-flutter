class TransactionDetails {
  int? id;
  String? noinvoice;
  String? name;
  double? price;
  int? qty;
  double? total;
  int? date;

  transactiondetailMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['noinvoice'] = noinvoice;
    mapping['name'] = name;
    mapping['price'] = price;
    mapping['qty'] = qty;
    mapping['total'] = total;
    mapping['date'] = date;

    return mapping;
  }
}
