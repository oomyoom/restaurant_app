import 'package:flutter/material.dart';
import 'package:basictestapp/colors.dart';

class AddTopping extends StatelessWidget {
  const AddTopping({super.key});

  //final _formKey = GlobalKey<FormState>();

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
                      'เพิ่มรายละเอียดเพิ่มเติม',
                      textAlign: TextAlign.center,
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
          //margin: EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(defaultPadding),
          child: const Text(
            'รายการอาหารที่ต้องการเพิ่ม',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
                labelText: 'ชื่ออาหารที่ต้องการเพิ่ม',
                labelStyle: TextStyle(fontSize: 16)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกชื่ออาหาร';
              }
              return null;
            },
          ),
        ),
      ]),
    );
  }
}
