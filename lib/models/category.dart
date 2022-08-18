class Category {
  int? id;
  String? name;

  // categoryMap() {
  //   var mapping = Map<String, dynamic>();
  //   mapping['id'] = id;
  //   mapping['name'] = name;
  //   return mapping;
  // }

  Map<String, dynamic> categoryMap() => {
        "id": id,
        "name": name,
      };
}
