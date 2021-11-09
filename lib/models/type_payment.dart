class TypePayment {
  int? id;
  String? name;

  typepaymentMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    return mapping;
  }
}
