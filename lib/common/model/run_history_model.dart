import 'dart:convert';
import 'package:equatable/equatable.dart';

List<RunHistoryModel> albumFromJson(String str) => List<RunHistoryModel>.from(
    json.decode(str).map((dynamic x) => RunHistoryModel.fromJson(x)));

String albumToJson(List<RunHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class RunHistoryModel extends Equatable {
  const RunHistoryModel(
      {this.id,
      this.avg,
      this.distance,
      this.date,
      this.steps,
      this.image,
      this.time,
      this.userId});
  factory RunHistoryModel.fromJson(Map<String, dynamic> json) =>
      RunHistoryModel(
        id: json['id'],
        avg: json['avg'],
        distance: json['distance'].toDouble(),
        date: json['date'],
        steps: json['steps'],
        image: json['image'],
        time: json['time'],
        userId: json['user_id'],
      );

  final int id;
  final int avg;
  final double distance;
  final String date;
  final int steps;
  final String image;
  final String time;
  final String userId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'avg': avg,
        'distance': distance,
        'date': date,
        'steps': steps,
        'image': image,
        'time': time,
        'userId': userId,
      };

  @override
  List<Object> get props =>
      [id, avg, distance, date, steps, image, time, userId];
}
