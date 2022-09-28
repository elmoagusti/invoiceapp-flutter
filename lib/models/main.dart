class Stores {
  final id;
  final outlet;
  final store;
  final address;
  final phone;
  final typetax;
  final tax;
  final header;
  final footer;
  final logo;

  Stores({
    required this.id,
    required this.outlet,
    required this.store,
    required this.address,
    required this.phone,
    required this.typetax,
    required this.tax,
    required this.header,
    required this.footer,
    required this.logo,
  });

  static Stores fromJson(json) => Stores(
        id: json['id'],
        outlet: json['outlet'],
        store: json["store"],
        address: json["address"],
        phone: json["phone"],
        typetax: json["typetax"],
        tax: json["tax"],
        header: json["header"],
        footer: json["footer"],
        logo: json["logo"],
      );

  Map<String, dynamic> storesMap() => {
        "id": id,
        "outlet": outlet,
        "store": store,
        "address": address,
        "phone": phone,
        "typetax": typetax,
        "tax": tax,
        "header": header,
        "footer": footer,
        "logo": logo,
      };
}
