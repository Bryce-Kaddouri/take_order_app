class CustomerModel {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String fName;
  final String lName;
  final String phoneNumber;
  final String countryCode;

  CustomerModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.fName,
    required this.lName,
    required this.phoneNumber,
    required this.countryCode,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json['customer_id'],
        /* createdAt: DateTime.parse(json['customer_created_at']),
        updatedAt: DateTime.parse(json['customer_updated_at']),*/
        fName: json['customer_f_name'],
        lName: json['customer_l_name'],
        phoneNumber: json['customer_phone_number'],
        countryCode: json['customer_country_code'],
      );

  factory CustomerModel.fromJsonFromTable(Map<String, dynamic> json) => CustomerModel(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        fName: json['f_name'],
        lName: json['l_name'],
        phoneNumber: json['phone_number'],
        countryCode: json['country_code'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'f_name': fName,
        'l_name': lName,
        'phone_number': phoneNumber,
      };
}
