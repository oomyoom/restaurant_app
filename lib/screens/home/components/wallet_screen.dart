import 'dart:async';
import 'package:basictestapp/screens/home/components/order.dart';
import 'package:flutter/material.dart';
import 'package:basictestapp/colors.dart';
// import 'package:fl_chart/fl_chart.dart';
// //import 'bar_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<dynamic> orderThisMonth = [];
  num totalTransaction = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<dynamic> orderThisMonthData = await getAllTransactionThisMonth();
    orderThisMonthData = await convertAllOrder(orderThisMonthData);
    totalTransaction = 0;
    num newTotalTransaction = 0;
    for (var value in orderThisMonthData) {
      newTotalTransaction += value.totalPrice;
    }
    setState(() {
      if (mounted) {
        orderThisMonth = orderThisMonthData;
        totalTransaction = newTotalTransaction;
      }
    });
  }

  // สร้าง map เพื่อเก็บ totalPrice ตามวันที่
  Map<DateTime, int> totalPriceByDate = {};

  @override
  Widget build(BuildContext context) {
    for (var order in orderThisMonth) {
      DateTime date = DateTime(order.creatDateTime.year,
          order.creatDateTime.month, order.creatDateTime.day);
      int totalPrice = order.totalPrice;

      if (totalPriceByDate.containsKey(date)) {
        totalPriceByDate[date] = totalPriceByDate[date]! + totalPrice;
      } else {
        totalPriceByDate[date] = totalPrice;
      }
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cMainColor,
        elevation: 0.0,
      ),
      body: Column(children: [
        SizedBox(
          height: size.height * 0.2,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.2 - 30,
                decoration: const BoxDecoration(
                    color: cMainColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'NOOMNIM',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(defaultPadding),
          //margin: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'จำนวนเงินทั้งหมดใน 30 วัน',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '฿ $totalTransaction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          child: orderThisMonth.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 300,
                    child: AspectRatio(
                      aspectRatio: 1.7,
                      child: BarChart(
                        BarChartData(
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(showTitles: false),
                            bottomTitles: SideTitles(
                              showTitles: true,
                              getTitles: (value) {
                                final date = totalPriceByDate.keys
                                    .toList()[value.toInt()];
                                return DateFormat('dd MMM')
                                    .format(date); // แสดงวันและเดือนเต็ม
                              },
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          barGroups: totalPriceByDate.keys.map((date) {
                            return BarChartGroupData(
                              x: date.day, // ใช้วันและเดือนโดยตรง
                              barRods: [
                                BarChartRodData(
                                  y: totalPriceByDate[date]!.toDouble(),
                                  width: 12,
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
        )
        // orderThisMonth.isEmpty
        //     ? Center(child: CircularProgressIndicator())
        //     : Center(
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.9,
        //           height: 300,
        //           child: AspectRatio(
        //             aspectRatio: 1.7,
        //             child: BarChart(
        //               BarChartData(
        //                 titlesData: FlTitlesData(
        //                   leftTitles: SideTitles(showTitles: false),
        //                   bottomTitles: SideTitles(
        //                     showTitles: true,
        //                     getTitles: (value) {
        //                       final date =
        //                           totalPriceByDate.keys.toList()[value.toInt()];
        //                       return DateFormat('dd MMM')
        //                           .format(date); // แสดงวันและเดือนเต็ม
        //                     },
        //                   ),
        //                 ),
        //                 borderData: FlBorderData(show: true),
        //                 barGroups: totalPriceByDate.keys.map((date) {
        //                   return BarChartGroupData(
        //                     x: date.day, // ใช้วันและเดือนโดยตรง
        //                     barRods: [
        //                       BarChartRodData(
        //                         y: totalPriceByDate[date]!.toDouble(),
        //                         width: 12,
        //                       ),
        //                     ],
        //                   );
        //                 }).toList(),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
      ]),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
    // return Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: cMainColor,
    //       elevation: 0.0,
    //     ),
    //     body: Column(children: [
    //       SizedBox(
    //         height: size.height * 0.2,
    //         child: Stack(
    //           children: [
    //             Container(
    //               height: size.height * 0.2 - 30,
    //               decoration: const BoxDecoration(
    //                   color: cMainColor,
    //                   borderRadius: BorderRadius.only(
    //                       bottomLeft: Radius.circular(40),
    //                       bottomRight: Radius.circular(40))),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   Text(
    //                     'RR Resturest',
    //                     style: Theme.of(context)
    //                         .textTheme
    //                         .headlineMedium
    //                         ?.copyWith(
    //                             color: Colors.white,
    //                             fontWeight: FontWeight.bold),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Container(
    //         alignment: Alignment.topLeft,
    //         padding: const EdgeInsets.all(defaultPadding),
    //         //margin: EdgeInsets.all(5.0),
    //         child: const Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             Text(
    //               'จำนวนเงินทั้งหมดของสัปดาห์',
    //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //             ),
    //             Text(
    //               'amount',
    //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //             )
    //           ],
    //         ),
    //       ),
    //       const Text(
    //         'รายได้ใน 7 วัน',
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //       ),
    //       const SizedBox(
    //         height: 16,
    //       ),
    //       const SizedBox(
    //         height: 250,
    //         width: 350,
    //         // child: orderThisMonth.isEmpty
    //       ? Center(child: CircularProgressIndicator())
    //       : Center(
    //           child: Container(
    //             width: MediaQuery.of(context).size.width * 0.9,
    //             height: 300,
    //             child: AspectRatio(
    //               aspectRatio: 1.7,
    //               child: BarChart(
    //                 BarChartData(
    //                   titlesData: FlTitlesData(
    //                     leftTitles: SideTitles(showTitles: false),
    //                     bottomTitles: SideTitles(
    //                       showTitles: true,
    //                       getTitles: (value) {
    //                         final date =
    //                             totalPriceByDate.keys.toList()[value.toInt()];
    //                         return DateFormat('dd MMM')
    //                             .format(date); // แสดงวันและเดือนเต็ม
    //                       },
    //                     ),
    //                   ),
    //                   borderData: FlBorderData(show: true),
    //                   barGroups: totalPriceByDate.keys.map((date) {
    //                     return BarChartGroupData(
    //                       x: date.day, // ใช้วันและเดือนโดยตรง
    //                       barRods: [
    //                         BarChartRodData(
    //                           y: totalPriceByDate[date]!.toDouble(),
    //                           width: 12,
    //                         ),
    //                       ],
    //                     );
    //                   }).toList(),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       //     })
    //     ]));
