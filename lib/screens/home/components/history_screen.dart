import 'dart:async';

import 'package:basictestapp/colors.dart';
import 'package:basictestapp/screens/home/components/order.dart';
import 'package:basictestapp/screens/home/components/orderdetails_screen.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> orderTransaction = [];
  num totalTransaction = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData(); // เรียกใน didChangeDependencies เมื่อคุณต้องการอัปเดตข้อมูลและคำนวณค่า totalTransaction
  }

  Future<void> fetchData() async {
    List<dynamic> orderData = await getAllTransaction();
    List<dynamic> orderThisWeekData = await getAllTransactionThisWeek();
    orderData = await convertAllOrder(orderData);
    orderThisWeekData = await convertAllOrder(orderThisWeekData);
    totalTransaction = 0;
    num newTotalTransaction = 0;
    for (var value in orderThisWeekData) {
      newTotalTransaction += value.totalPrice;
    }
    if (mounted) {
      setState(() {
        orderTransaction = orderData;
        totalTransaction = newTotalTransaction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cMainColor,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                ),
                const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "NOOMNIM",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(defaultPadding),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'รายได้ทั้งหมดของสัปดาห์นี้',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                            color: cBackgoundColor),
                      ),
                      Text(
                        '฿ $totalTransaction',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cBackgoundColor),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: orderTransaction.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ประวัติรายการอาหารที่ถูกสั่ง',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children:
                                  orderTransaction.asMap().entries.map((e) {
                                final value = e.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderdetailsScreen(
                                                      order: value,
                                                    )));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.black26),
                                                bottom: BorderSide(
                                                    color: Colors.black26))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: value.isRecieved ==
                                                          true
                                                      ? Colors.green
                                                      : const Color(0xFFFFD700),
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.03,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'หมายเลขออเดอร์ ${value.orderId}'),
                                                    Text(
                                                      value.creatDateTime
                                                          .toString()
                                                          .substring(0, 16),
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.lightBlue),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '฿ ${value.totalPrice}',
                                              style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.height * 0.02),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
