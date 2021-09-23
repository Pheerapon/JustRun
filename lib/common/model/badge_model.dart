import 'dart:convert';
import 'package:equatable/equatable.dart';

List<BadgeModel> albumFromJson(String str) => List<BadgeModel>.from(
    json.decode(str).map((dynamic x) => BadgeModel.fromJson(x)));

String albumToJson(List<BadgeModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

// ignore: must_be_immutable
class BadgeModel extends Equatable {
  BadgeModel({this.id, this.level, this.title, this.subtitle, this.acquired});
  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'],
      level: json['level'],
      title: json['title'],
      subtitle: json['subtitle'],
      acquired: false,
    );
  }
  final int id;
  final int level;
  final String title;
  final String subtitle;
  bool acquired;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'level': level,
        'title': title,
        'subtitle': subtitle,
        'acquired': acquired,
      };

  @override
  List<Object> get props => [id, level, title, subtitle, acquired];
}
