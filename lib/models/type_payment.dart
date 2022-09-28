class TypePayments {
  final id;
  final name;

  TypePayments({
    required this.id,
    required this.name,
  });

  static TypePayments fromJson(json) => TypePayments(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> typePaymentsMap() => {
        "id": id,
        "name": name,
      };
}
