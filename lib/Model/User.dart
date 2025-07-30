class User {
  late String id;
  late String name;
  late String email;
  late String phone;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
  factory User.formJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['fullName'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
