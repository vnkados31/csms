// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FeedbackReq {
  final String id;
  final String feedText;
  final String ratingText;
  final double psNumber;
  final String today;
  FeedbackReq({
    required this.id,
    required this.feedText,
    required this.ratingText,
    required this.psNumber,
    required this.today,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'feedText': feedText,
      'ratingText': ratingText,
      'psNumber': psNumber,
      'today': today,
    };
  }

  factory FeedbackReq.fromMap(Map<String, dynamic> map) {
    return FeedbackReq(
      id: map['_id'] as String,
      feedText: map['feedText'] as String,
      ratingText: map['ratingText'] as String,
      psNumber: map['psNumber']?.toDouble() ?? 0.0,
      today: map['today'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedbackReq.fromJson(String source) =>
      FeedbackReq.fromMap(json.decode(source) as Map<String, dynamic>);
}
