import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final int psNumber;
  final String password;
  final int couponsLeft;
  final String foodType;
  final String userType;
  final String dob;
  final String token;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.psNumber,
      required this.password,
      required this.dob,
      required this.couponsLeft,
      required this.foodType,
      required this.userType,
      required this.token});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'psNumber': psNumber,
      'password': password,
      'dob': dob,
      'coupons_left': couponsLeft,
      'food_type': foodType,
      'user_type': userType,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      psNumber: map['psNumber']?.toInt() ?? 0,
      password: map['password'] ?? '',
      dob: map['dob'] ?? '',
      couponsLeft: map['couponsLeft']?.toInt() ?? 0,
      foodType: map['foodType'] ?? '',
      userType: map['userType'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
