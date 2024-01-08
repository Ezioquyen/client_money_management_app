import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartSample extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const LineChartSample(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true, interval: 100000, reservedSize: 50)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                      reservedSize: 45)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false))),

          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          minX: 0,
          maxX: data.length.toDouble() - 1,
          minY: 0,
          maxY: getMaxTotalMoney(),
          // You need to implement this method
          lineBarsData: [
            LineChartBarData(
              spots: getSpots(),
              color: Colors.deepPurple,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    List<String> monthYear = data[value.toInt()]["byMonth"].toString().split("/");
    Widget text = Text("${monthYear[1]}/${monthYear[0]}");

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  double getMaxTotalMoney() {
    double max = 0;
    for (var data in data) {
      double totalMoney = data["totalMoney"] / 1.0;
      if (totalMoney > max) {
        max = totalMoney;
      }
    }
    return max;
  }

  List<FlSpot> getSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      double totalMoney = data[i]["totalMoney"] / 1.0;
      spots.add(FlSpot(i.toDouble(), totalMoney));
    }
    return spots;
  }
}

class PieChartSample extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const PieChartSample(this.data, {super.key});

  @override
  State<StatefulWidget> createState() {
    return PiChartState();
  }
}

class PiChartState extends State<PieChartSample> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 300,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: getSections(),
              borderData: FlBorderData(
                show: true,
              ),
            ),
          ),
        ),
        SizedBox(width: 100,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.data.length,
            itemExtent: 80,
            itemBuilder: (context, index) {
              return SizedBox(
                  height: 80,
                  child: Column(
                    children: [
                      Text(widget.data[index]["paymentGroupName"].toString()),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(color: getColor(index)),
                      )
                    ],
                  ));
            },
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> getSections() {
    List<PieChartSectionData> sections = [];
    int index = 0;
    for (var data in widget.data) {
      double totalMoney = data["totalMoney"] / 1.0;
      int paymentGroup = data["paymentGroup"];
      sections.add(
        PieChartSectionData(
          value: totalMoney,
          title:
              '${NumberFormat('###,###').format(totalMoney).split(",")[0]}K VND',
          color: getColor(index),
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    }

    return sections;
  }

  Color getColor(int paymentGroup) {
    switch (paymentGroup) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
