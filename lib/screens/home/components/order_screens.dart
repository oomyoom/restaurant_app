//import 'package:basictestapp/screens/home/components/body.dart';
import 'dart:async';
import 'dart:convert';

import 'package:basictestapp/colors.dart';
import 'package:basictestapp/screens/home/components/addmenu.dart';
import 'package:basictestapp/screens/home/components/fixedmenu_screen.dart';
import 'package:basictestapp/screens/home/components/order.dart';
import 'package:basictestapp/screens/home/components/orderdetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderScreens extends StatefulWidget {
  const OrderScreens({Key? key}) : super(key: key);

  @override
  _OrderScreensState createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens> {
  List<dynamic> orderHist = [];
  List<Menu3> menu = [];

  Future<List<dynamic>> getAllMenu() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.84:3333/menu/get'));

    if (response.statusCode == 200) {
      List<dynamic> allMenu = json.decode(response.body);
      return allMenu;
    } else {
      // กรณีเกิดข้อผิดพลาดในการรับข้อมูล
      return [];
    }
  }

  Future<void> convertAllMenu() async {
    final allMenu = await getAllMenu();
    menu = allMenu.map((data) {
      List<int> imageData = (data['menu_image']['data'] as List).cast<int>();

      return Menu3(
        id: data['menu_id'],
        title: data['menu_title'],
        image: imageData,
        price: data['menu_price'],
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    convertAllMenu();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    List<dynamic> orderData = await getAllOrder(); // รอให้ Future ทำงานเสร็จ
    orderData = await convertAllOrder(orderData);
    if (mounted) {
      // Check if the widget is still mounted before updating state
      setState(() {
        orderHist = orderData;
      });
    }
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, int orderId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยัน'),
          content: const Text('คุณได้แล้วรับออเดอร์แล้วใช่ไหม'),
          actions: <Widget>[
            TextButton(
              child: const Text('ใช่'),
              onPressed: () {
                orderCompleted(orderId);
                fetchData();
                Navigator.of(context).pop(); // ปิด dialog
              },
            ),
            TextButton(
              child: const Text('ไม่'),
              onPressed: () {
                // ทำสิ่งที่คุณต้องการเมื่อผู้ใช้กด Yes ที่นี่
                Navigator.of(context).pop(); // ปิด dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> orderCompleted(int orderId) async {
    await http.patch(Uri.parse('http://192.168.1.84:3333/order/completed'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'order_id': orderId}));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'NOOMNIM',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: cMainColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.2,
              child: Stack(
                children: [
                  Container(
                      height: size.height * 0.2 - 27,
                      decoration: const BoxDecoration(
                          color: cMainColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          )),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Addmenu()));
                              },
                              style: TextButton.styleFrom(
                                  elevation: 10.0,
                                  fixedSize: const Size(100, 60),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                              child: const Text(
                                'เพิ่มเมนู',
                                style: TextStyle(
                                  color: cTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FixedmenuScreen(
                                                menu: menu,
                                              )));
                                },
                                style: TextButton.styleFrom(
                                    elevation: 10.0,
                                    fixedSize: const Size(100.0, 60.0),
                                    backgroundColor: cTextColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                child: const Text(
                                  'แก้ไขเมนู',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ))
                          ])),
                ],
              ),
            ),
            Expanded(
              child: orderHist.isEmpty
                  ? Center(
                      child:
                          CircularProgressIndicator()) // แสดง Indicator ถ้า orderHist ยังว่าง
                  : Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ลำดับรายการอาหาร',
                                style: TextStyle(
                                  color: cTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Column(
                                children: orderHist.asMap().entries.map((e) {
                                  final value = e.value;
                                  Order2 order = value;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .005,
                                                  ),
                                                  Text(
                                                    order.creatDateTime
                                                        .toString()
                                                        .substring(0, 16),
                                                  ),
                                                  Text(
                                                      'หมายเลขออเดอร์ ${value.orderId}'),
                                                  Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: order.orderItems
                                                          .asMap()
                                                          .entries
                                                          .map((entry) {
                                                        final value =
                                                            entry.value;

                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  '  - ${value.foodItem.title} x ${value.quantity}',
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!,
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              value.specifyItem,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!,
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .01,
                                                            ),
                                                          ],
                                                        );
                                                      }).toList()),
                                                  Text(
                                                      'เบอร์ลูกค้า ${value.phonenumber}'),
                                                  Text(
                                                    'รับเงินแล้ว ฿ ${value.totalPrice}',
                                                    style: const TextStyle(
                                                        color:
                                                            Colors.lightBlue),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .005,
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _showConfirmationDialog(
                                                      context, value.orderId);
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green)),
                                                child: const Text(
                                                  'เสร็จแล้ว',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ));
  }
}
