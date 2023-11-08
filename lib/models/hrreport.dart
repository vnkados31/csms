import 'dart:convert';

class HrReport {
  final int psNumber;
  final String date;
  final String? id;

  HrReport(
      {required this.psNumber,
      required this.date,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'psNumber': psNumber,
      'date' : date,
      'id': id
    };
  }

  factory HrReport.fromMap(Map<String, dynamic> map) {
    return HrReport(
      psNumber: map['name'] ?? 0,
      date: map['day'] ?? '',
      id: map['_id']
    );
  }

  String toJson() => json.encode(toMap());

  factory HrReport.fromJson(String source) =>
      HrReport.fromMap(json.decode(source));
}
