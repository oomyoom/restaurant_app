// import 'package:basictestapp/components/BarChart/bar_data.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// class MyBarChart extends StatelessWidget {
//   final List weeklySummary;
//   const MyBarChart({
//     super.key,
//     required this.weeklySummary,
//   });

//   @override
//   Widget build(BuildContext context) {
//     BarData myBarData = BarData(
//       sunAmount: weeklySummary[1],
//       monAmount: weeklySummary[2],
//       tueAmount: weeklySummary[3],
//       wedAmount: weeklySummary[4],
//       thuAmount: weeklySummary[5],
//       friAmount: weeklySummary[6],
//       satAmount: weeklySummary[7],
//     );

//     myBarData.intializrBarData();

//     return BarChart(
//       BarChartData(
//         maxY: 100,
//         minY: 0,
//         barGroups: myBarData.barData.map(
//           (data) => BarChartGroupData(
//             x: data.x,
//             barRods: [
//               BarChartRodData(y: data.y),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
