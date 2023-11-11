import 'package:basictestapp/colors.dart';
import 'package:flutter/material.dart';

//import '../../colors.dart';

class Profile_Screen extends StatelessWidget {
  const Profile_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: cMainColor,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: const Column(
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.grey,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'ชื่อผู้ใช้',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              'อีเมล',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              'เบอร์โทร',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
