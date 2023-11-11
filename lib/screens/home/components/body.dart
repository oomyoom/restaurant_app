import 'dart:async';

import 'package:basictestapp/colors.dart';
import 'package:basictestapp/screens/home/components/history_screen.dart';
import 'package:basictestapp/screens/home/components/order.dart';
import 'package:basictestapp/screens/home/components/order_screens.dart';
import 'package:basictestapp/screens/home/components/profile_screen.dart';
import 'package:basictestapp/screens/home/components/wallet_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Timer _notificationTimer;
  int unreadNotificationCount = 0; // เริ่มต้นที่ 0
  num totalTransaction = 0;
  List orderThisMonth = [];

  @override
  void initState() {
    super.initState();

    final orderData = getAllOrder();
    orderData.then((data) {
      setState(() {
        unreadNotificationCount =
            data.where((item) => !(item['isCompleted'] == 1)).length;
      });
    });

    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final orderData = getAllOrder();
      orderData.then((data) {
        if (mounted) {
          // Check if the widget is still in the tree
          setState(() {
            unreadNotificationCount =
                data.where((item) => !(item['isCompleted'] == 1)).length;
          });
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData(); // เรียกใน didChangeDependencies เมื่อคุณต้องการอัปเดตข้อมูลและคำนวณค่า totalTransaction
  }

  Future<void> fetchData() async {
    List<dynamic> orderThisdayData = await getAllTransactionThisDay();
    orderThisdayData = await convertAllOrder(orderThisdayData);
    totalTransaction = 0;
    num newTotalTransaction = 0;
    for (var value in orderThisdayData) {
      newTotalTransaction += value.totalPrice;
    }
    if (mounted) {
      setState(() {
        totalTransaction = newTotalTransaction;
      });
    }
  }

  @override
  void dispose() {
    _notificationTimer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.2,
          child: Stack(
            children: [
              Container(
                  height: size.height * 0.2 - 27,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      color: cMainColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      )),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "รายได้ของวันนี้",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          '฿ $totalTransaction',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ])),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderScreens()));
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(10.0),
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: cMainColor),
                      child: const Column(
                        children: [
                          Text(
                            'Orders',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.food_bank,
                            size: 100,
                          ),
                        ],
                      )),
                  if (unreadNotificationCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 25,
                          minHeight: 25,
                        ),
                        child: Center(
                          child: Text(
                            unreadNotificationCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HistoryScreen()));
              },
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(10.0),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: cMainColor),
                  child: const Column(
                    children: [
                      Text(
                        'Recent',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.history_outlined,
                        size: 100,
                      ),
                    ],
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletScreen()));
              },
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(10.0),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: cMainColor),
                  child: const Column(
                    children: [
                      Text(
                        'Pocket',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.wallet_outlined,
                        size: 100,
                      ),
                    ],
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(10.0),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: cMainColor),
                  child: const Column(
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.person_2_rounded,
                        size: 100,
                      ),
                    ],
                  )),
            ),
          ],
        )
      ],
    );
  }
}
