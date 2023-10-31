import 'dart:convert';

class MenuItem {
  final String name;
  final String day;
  final String type;
  final String? id;

  MenuItem(
      {required this.name,
      required this.day,
      required this.type,
      this.id});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'day' : day,
      'type' : type,
      'id': id,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      name: map['name'] ?? '',
      day: map['day'] ?? '',
      type: map['type'] ?? '',   
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItem.fromJson(String source) =>
      MenuItem.fromMap(json.decode(source));
}
