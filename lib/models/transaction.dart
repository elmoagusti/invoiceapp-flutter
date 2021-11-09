class Transaction {
  int? id;
  String? noinvoice;
  String? name;
  double? tax;
  double? subtotal;
  double? discount;
  double? nettotal;
  int? date;
  String? type;
  double? money;
  double? change;

  transactionMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['noinvoice'] = noinvoice;
    mapping['name'] = name;
    mapping['tax'] = tax;
    mapping['subtotal'] = subtotal;
    mapping['discount'] = discount;
    mapping['nettotal'] = nettotal;
    mapping['date'] = date;
    mapping['type'] = type;
    mapping['money'] = money;
    mapping['change'] = change;

    return mapping;
  }
}
