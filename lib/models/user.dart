import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String ps_number;
  final String password;
  final String coupons_left;
  final String food_type;
  final String user_type;
  final String dob;
  final String token;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.ps_number,
      required this.password,
      required this.dob,
      required this.coupons_left,
      required this.food_type,
      required this.user_type,
      required this.token});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'ps_number': ps_number,
      'password': password,
      'dob': dob,
      'coupons_left': coupons_left,
      'food_type': food_type,
      'user_type': user_type,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      ps_number: map['ps_number'] ?? '',
      password: map['password'] ?? '',
      dob: map['dob'] ?? '',
      coupons_left: map['coupons_left'] ?? '',
      food_type: map['food_type'] ?? '',
      user_type: map['user_type'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
