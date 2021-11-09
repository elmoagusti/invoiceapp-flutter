class Mains {
  int? id;
  String? outlet;
  String? store;
  String? address;
  String? phone;
  int? typetax;
  double? tax;
  String? header;
  String? footer;
  String? logo;
  mainsMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['outlet'] = outlet;
    mapping['store'] = store;
    mapping['address'] = address;
    mapping['phone'] = phone;
    mapping['typetax'] = typetax;
    mapping['tax'] = tax;
    mapping['header'] = header;
    mapping['footer'] = footer;
    mapping['logo'] = logo;

    return mapping;
  }
}
