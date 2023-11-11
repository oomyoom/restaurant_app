import 'dart:typed_data';

import 'package:basictestapp/screens/home/components/order.dart';
import 'package:flutter/material.dart';
import 'package:basictestapp/colors.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class FixedmenuScreen extends StatefulWidget {
  const FixedmenuScreen({Key? key, required this.menu}) : super(key: key);
  final List<Menu3> menu;

  @override
  _FixedmenuScreenState createState() => _FixedmenuScreenState();
}

class _FixedmenuScreenState extends State<FixedmenuScreen> {
  Future<void> menuAvailable(int menuId, int isClose) async {
    final response =
        await http.patch(Uri.parse('http://192.168.1.84:3333/menu/available'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'menu_id': menuId, 'available': isClose}));

    if (response.statusCode == 200) {
      if (isClose == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('เปิดเมนูอาหารเรียบร้อย'),
            duration: Duration(seconds: 3), // ระยะเวลาที่แจ้งเตือนแสดง
          ),
        );
      } else if (isClose == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ปิดเมนูอาหารเรียบร้อย'),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NOOMNIM',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            //margin: EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'รายการอาหารที่ต้อการแก้ไข',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Image.asset(name)
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    children: widget.menu.map((e) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.black26),
                                    bottom: BorderSide(color: Colors.black26))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1.25,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              defaultPadding / 2),
                                          child: Image.memory(
                                            Uint8List.fromList(e.image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.05,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('${e.title}'),
                                          Text(
                                            '฿ ${e.price}',
                                            style: const TextStyle(
                                                color: Colors.lightBlue),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await menuAvailable(e.id, 1);
                                      },
                                      child: Text('มี'),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  cMainColor)),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await menuAvailable(e.id, 0);
                                      },
                                      child: Text('หมด'),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  cTextColor)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          )
                        ],
                      );
                    }).toList(),
                  )))
                ],
              ))
        ]));
  }
}
