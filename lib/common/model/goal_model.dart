import 'dart:convert';
import 'package:equatable/equatable.dart';

List<GoalModel> albumFromJson(String str) => List<GoalModel>.from(
    json.decode(str).map((dynamic x) => GoalModel.fromJson(x)));

String albumToJson(List<GoalModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class GoalModel extends Equatable {
  const GoalModel({this.time, this.distance, this.step});

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      distance: json['distance'].toDouble(),
      time: json['time'],
      step: json['step'],
    );
  }

  final int time;
  final int step;
  final double distance;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'distance': distance,
        'time': time,
        'step': step,
      };

  @override
  List<Object> get props => [time, step, distance];
}
