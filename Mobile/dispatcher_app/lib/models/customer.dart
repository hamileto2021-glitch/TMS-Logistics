class Customer {
  final int id;
  final String customerCode;
  final String companyName;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String country;

  Customer({
    required this.id,
    required this.customerCode,
    required this.companyName,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"] ?? 0,
      customerCode: json["customerCode"] ?? "",
      companyName: json["companyName"] ?? "",
      contactPerson: json["contactPerson"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerCode": customerCode,
      "companyName": companyName,
      "contactPerson": contactPerson,
      "phone": phone,
      "email": email,
      "address": address,
      "city": city,
      "state": state,
      "country": country,
    };
  }
}