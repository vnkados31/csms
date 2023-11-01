import 'dart:convert';

class Qrmodel {
  final String name;
  final String email;
  final double psNumber;
  final double vegUsers;
  final double nonVegUsers;
  final double dietUsers;
  final double totalUsers;
  final double scannedBy;
  final double couponsLeft;
  final String date;
  final String? id;

  Qrmodel(
      {required this.name,
      required this.email,
      required this.psNumber,
      required this.vegUsers,
      required this.nonVegUsers,
      required this.dietUsers,
      required this.totalUsers,
      required this.scannedBy,
      required this.couponsLeft,
      required this.date,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'psNumber': psNumber,
      'vegUsers': vegUsers,
      'nonVegUsers': nonVegUsers,
      'dietUsers': dietUsers,
      'totalUsers': totalUsers,
      'scannedBy': scannedBy,
      'couponsLeft': couponsLeft,
      'date': date,
      'id': id,
    };
  }

  factory Qrmodel.fromMap(Map<String, dynamic> map) {
    return Qrmodel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      psNumber: map['psNumber']?.toDouble() ?? 0.0,
      vegUsers: map['vegUsers']?.toDouble() ?? 0.0,
      nonVegUsers: map['nonVegUsers']?.toDouble() ?? 0.0,
      dietUsers: map['dietUsers']?.toDouble() ?? 0.0,
      totalUsers: map['totalUsers']?.toDouble() ?? 0.0,
      scannedBy: map['scannedBy']?.toDouble() ?? 0.0,
      couponsLeft: map['couponsLeft']?.toDouble() ?? 0.0,
      date: map['date'] ?? '',
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Qrmodel.fromJson(String source) =>
      Qrmodel.fromMap(json.decode(source));
}
