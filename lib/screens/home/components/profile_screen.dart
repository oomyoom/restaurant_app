import 'package:flutter/material.dart';
import 'package:basictestapp/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int number;

  @override
  void initState() {
    super.initState();
  }

  Future<void> openClose(int isClose) async {
    final response = await http.patch(
        Uri.parse('http://192.168.1.84:3333/restaurant/isClose'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'available': isClose}));

    if (response.statusCode == 200) {
      if (isClose == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เปิดร้านอาหารเรียบร้อย'),
            duration: Duration(seconds: 3), // ระยะเวลาที่แจ้งเตือนแสดง
          ),
        );
      } else if (isClose == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ปิดร้านอาหารเรียบร้อย'),
            duration: Duration(seconds: 3), // ระยะเวลาที่แจ้งเตือนแสดง
          ),
        );
      }
    } else {
      // กรณีเกิดข้อผิดพลาดในการรับข้อมูล
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('เกิดข้อผิดพลาดในการอัปเดตข้อมูล'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cMainColor,
        elevation: 0.0,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Profile',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await openClose(1);
                },
                style: TextButton.styleFrom(
                    elevation: 10.0,
                    fixedSize: const Size(100, 60),
                    backgroundColor: cMainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                child: const Text(
                  'เปิด',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await openClose(0);
                },
                style: TextButton.styleFrom(
                    elevation: 10.0,
                    fixedSize: const Size(100, 60),
                    backgroundColor: cTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                child: const Text(
                  'ปิด',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/images/logo.jpg'),
            ),
          ),
          Text(
            'เบอร์โทร 081-123-4567',
            style: TextStyle(
                fontSize: 16, color: cTextColor, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
