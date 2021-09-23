import 'dart:convert';
import 'package:equatable/equatable.dart';

List<DailyRewardModel> albumFromJson(String str) => List<DailyRewardModel>.from(
    json.decode(str).map((dynamic x) => DailyRewardModel.fromJson(x)));

String albumToJson(List<DailyRewardModel> data) =>
    json.encode(List<dynamic>.from(data.map<dynamic>((x) => x.toJson())));

class DailyRewardModel extends Equatable {
  const DailyRewardModel({this.daysInRow, this.currentDaily});

  factory DailyRewardModel.fromJson(Map<String, dynamic> json) {
    return DailyRewardModel(
      daysInRow: json['days_row'],
      currentDaily: json['current_daily'],
    );
  }

  final int daysInRow;
  final String currentDaily;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'days_row': daysInRow,
        'current_daily': currentDaily,
      };

  @override
  List<Object> get props => [daysInRow, currentDaily];
}
