import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waste_time/models/scheduleModel.dart';

class Sample extends StatefulWidget {
  List<ScheduleModel> data;

  Sample({required this.data, Key? key}) : super(key: key);
  @override
  _Sample createState() => _Sample();
}

class _Sample extends State<Sample> {
  // List data = [
  //   {'no': 2, 'date': '2023-07-22 11:45:36.769097'},
  //   {
  //     'no': 3,
  //     'date': '2023-07-22 11:45:05.938679',
  //   },
  //   {
  //     'no': 4,
  //     'date': '2023-07-22 12:47:10.670396',
  //   },
  //   {
  //     'no': 5,
  //     'date': '2023-07-22 12:49:10.670396',
  //   },
  //   {'no': 6, 'date': '2023-07-22 11:48:36.773880'},
  //   {'no': 3, 'date': '2023-07-22 13:48:36.773880'},
  //   {'no': 9, 'date': '2023-07-22 13:49:36.773880'},
  //   {'no': 9, 'date': '2023-07-22 14:49:36.773880'},
  //   {'no': 9, 'date': '2023-07-22 15:49:36.773880'},
  //   {'no': 9, 'date': '2023-07-22 15:49:36.773880'},
  //   {'no': 9, 'date': '2023-07-22 15:49:36.773880'},
  //   {'no': 9, 'date': '2023-07-22 16:49:36.773880'},
  // ];

  List todayList = [];
  List weekList = [];

  @override
  void initState() {
    touchedValue = -1;
    organiseToday();
    print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    print(widget.data);
    activeList = todayList;

    super.initState();
  }

  // organiseWeelky() {
  //   DateTime thisWeek = DateTime.now();

  //   for (var rec in data) {
  //     DateTime date = DateTime.parse(rec['date']);
  //     if(date.month == thisWeek.month && date.);
  //   }
  // }
  Map<String, int> hourly = {};
  List results = [];

  organiseToday() {
    DateTime today = DateTime.now();

    for (ScheduleModel rec in widget.data) {
      DateTime someDay = DateTime.parse(rec.dateCreated);
      print('sssssssssssssssssssssssssssssss');
      print(rec.dateCreated);

      if (someDay.day == today.day &&
          someDay.month == today.month &&
          someDay.year == today.year) {
        // DateFormat.jm().format(someDay);
        String key = DateFormat.j().format(someDay);
        print('oooooooooooooooooooooooooooo');
        if (hourly.containsKey(key)) {
          int count = hourly[key]!;
          count = count + 1;
          hourly[key] = count;
        } else {
          print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
          hourly[key] = 1;
          print('hhhhhhhhhhhhhhhhhhhhhh');
          print(hourly);
          Map<String, int> tmp = {};
          tmp[key] = 1;
          results.add(tmp);
        }
        // todayList.add(rec);
      }
    }
    setState(() {});
    print('999999999999999999999999');
    print(todayList);
    print(hourly);
    print(results);
  }

  List? activeList;

  @override
  Widget build(BuildContext context) {
    double ovWidth = MediaQuery.of(context).size.width;
    double ovHeight = MediaQuery.of(context).size.height;

    return results.isNotEmpty
        ? Container(
            height: 300,
            // color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      //     child: DropdownButton<List<dynamic>>(
                      //   value: activeList,
                      //   onChanged: (e) {
                      //     setState(() {
                      //       activeList = e;
                      //     });
                      //   },
                      //   items: [
                      //     DropdownMenuItem(
                      //       child: Text('Today'),
                      //       value: results,
                      //     ),
                      //     DropdownMenuItem(
                      //       child: Text('Week'),
                      //       value: weekList,
                      //     )
                      //   ],
                      // )
                      ),
                ),
                Container(
                  height: 250,
                  width: 340,
                  // color: Colors.red,
                  child: LineChart(LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: results.asMap().entries.map((e) {
                          // print('tttttttttttttttttttttttttt');
                          // print(hourly[e.value.keys.first]!.toDouble());
                          return FlSpot(e.key.toDouble(),
                              hourly[e.value.keys.first]!.toDouble());
                        }).toList(),
                        isCurved: true,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        gradient:
                            LinearGradient(colors: [Colors.red, Colors.green]),
                        preventCurveOverShooting: true,
                      )
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: Text('Number of pickups'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 46,
                          getTitlesWidget: leftTitleWidgets,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text('Days'),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                    ),
                  )),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  late double touchedValue;
  Color bottomTouchedTextColor = Colors.red;
  Color? bottomTextColor = Colors.purple;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final isTouched = value == touchedValue;
    final style = TextStyle(
      color: isTouched ? bottomTouchedTextColor : bottomTextColor,
      fontWeight: FontWeight.bold,
    );

    if (value % 1 != 0) {
      return Container();
    }
    return SideTitleWidget(
      space: 4,
      axisSide: meta.axisSide,
      fitInside: fitInsideBottomTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0)
          : SideTitleFitInsideData.disable(),
      child: Text(
        results[value.toInt()].keys.first,
        style: style,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0) {
      return Container();
    }
    final style = TextStyle(
      color: Colors.black,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '';
        break;
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      fitInside: fitInsideLeftTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta)
          : SideTitleFitInsideData.disable(),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  bool fitInsideLeftTitle = false;
  bool fitInsideBottomTitle = true;
}
