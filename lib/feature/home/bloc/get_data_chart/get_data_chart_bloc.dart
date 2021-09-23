import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_get_data_chart.dart';

class GetDataChartBloc extends Bloc<GetDataChartEvent, GetDataChartState> {
  GetDataChartBloc() : super(GetDataChartInitial());

  String getDay({int day}) {
    switch (day) {
      case 1:
        return 'M';
      case 2:
        return 'T';
      case 3:
        return 'W';
      case 4:
        return 'T';
      case 5:
        return 'F';
      case 6:
        return 'S';
      default:
        return 'S';
    }
  }

  @override
  Stream<GetDataChartState> mapEventToState(GetDataChartEvent event) async* {
    if (event is GetDataEvent) {
      final List<List<int>> runHistory7Day = [];
      final List<Map<String, dynamic>> steps = [];
      try {
        yield GetDataChartLoading();
        for (int i = 7; i > 0; i--) {
          final List<int> step = [];
          for (var element in event.runHistories) {
            if (DateTime.parse(element.date).day ==
                DateTime.now().subtract(Duration(days: i - 1)).day) {
              step.add(element.steps);
            }
          }
          runHistory7Day.add(step);
        }
        for (int i = 0; i < runHistory7Day.length; i++) {
          steps.add(<String, dynamic>{
            'title': getDay(
                day: DateTime.now().subtract(Duration(days: 6 - i)).weekday),
            'steps': runHistory7Day[i].isNotEmpty
                ? runHistory7Day[i].reduce((value, element) => value + element)
                : 0
          });
        }
        yield GetDataChartSuccess(steps: steps, runHistory7Day: runHistory7Day);
      } catch (e) {
        yield GetDataChartFailure(error: e.toString());
      }
    }
  }
}
