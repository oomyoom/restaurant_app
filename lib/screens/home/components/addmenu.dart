//import 'package:basictestapp/screens/home/components/addedtopping.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:basictestapp/screens/home/components/order_screens.dart';
import 'package:http/http.dart' as http;

import 'package:basictestapp/utils/imageOper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import '../../../colors.dart';

class Addmenu extends StatefulWidget {
  const Addmenu({Key? key}) : super(key: key);

  @override
  _AddmenuState createState() => _AddmenuState();
}

class _AddmenuState extends State<Addmenu> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController menuTitleController = TextEditingController();
  final TextEditingController menuPriceController = TextEditingController();
  final TextEditingController categoryTitleController = TextEditingController();
  final TextEditingController optionTitleController = TextEditingController();
  final TextEditingController optionPriceController = TextEditingController();

  List<Map<String, dynamic>> categories = [];

  File? _image;
  bool _hasImage = false;

  Future<void> menuCreation(
    File imageFile,
    Map<String, dynamic> menu,
  ) async {
    final url = Uri.parse('http://192.168.1.84:3333/menu/create');
    final request = http.MultipartRequest('POST', url);
    request.fields['menuData'] = jsonEncode(menu);

    request.files.add(http.MultipartFile(
      'image',
      imageFile.readAsBytes().asStream(),
      imageFile.lengthSync(),
      filename: 'image.jpg',
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('สร้างเมนูสำเร็จ'),
          duration: Duration(seconds: 3), // ระยะเวลาที่แจ้งเตือนแสดง
        ),
      );
      menuTitleController.text = '';
      menuPriceController.text = '';
      categories.clear();
      while (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OrderScreens()));
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('เมนูนี้มีอยู่ในระบบแล้ว'),
          duration: Duration(seconds: 3), // ระยะเวลาที่แจ้งเตือนแสดง
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('สร้างเมนูล้มเหลว'),
          duration: Duration(seconds: 3), // ระยะเวลาที่แจ้งเตือนแสดง
        ),
      );
    }
  }

  Future<void> createMenuData() async {
    if (categories.isEmpty) {
      categories = [
        {
          'category_title': "ธรรมดา/พิเศษ",
          'options': [
            {'option_title': "ธรรมดา", 'option_price': 0.0},
            {'option_title': "พิเศษ", 'option_price': 10.0},
          ],
        },
      ];
    }

    final menu = {
      'menu_title': menuTitleController.text,
      'menu_price': double.parse(menuPriceController.text),
      'categories': categories,
    };

    await menuCreation(_image!, menu);

    // Clear the text fields
    menuTitleController.text = '';
    menuPriceController.text = '';
    categories.clear();
  }

  void openCreateCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final GlobalKey<FormState> _categoryFormKey = GlobalKey<FormState>();
        return AlertDialog(
          title: Text('ประเภทท็อปปิ้ง'),
          content: Form(
            key: _categoryFormKey, // กำหนด GlobalKey ของฟอร์ม(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(categoryTitleController, "ชื่อประเภทท็อปปิ้ง",
                    TextInputType.name),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_categoryFormKey.currentState!.validate()) {
                      // ถ้าข้อมูลผ่าน validator ให้ทำอย่างอื่น
                      addOptionToCategory();
                    }
                  },
                  child: Text("เพิ่มรายการท็อปปิ้ง"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addOptionToCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final GlobalKey<FormState> _optionsFormKey = GlobalKey<FormState>();
        final List<Map<String, dynamic>> options = [];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('เพิ่มรายการท็อปปิ้ง'),
              content: Form(
                key: _optionsFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTextField(optionTitleController, "ชื่อท็อปปิ้ง",
                        TextInputType.name),
                    SizedBox(width: 16),
                    buildTextField(optionPriceController, "ราคาท็อปปิ้ง",
                        TextInputType.number),
                    ElevatedButton(
                      onPressed: () {
                        if (_optionsFormKey.currentState!.validate()) {
                          setState(() {
                            options.add({
                              'option_title': optionTitleController.text,
                              'option_price':
                                  double.parse(optionPriceController.text),
                            });
                            optionTitleController.text = '';
                            optionPriceController.text = '';
                            FocusScope.of(context).unfocus();
                          });
                        }
                      },
                      child: Text("เพิ่มรายการท็อปปิ้ง"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (options.isNotEmpty) {
                          setState(() {
                            categories.add({
                              'category_title': categoryTitleController.text,
                              'options': List.from(options),
                            });
                            categoryTitleController.text = '';
                          });
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.of(context).pop();
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('ผิดพลาด'),
                                content: Text('คุณยังไม่ได้ใส่ท็อปปิ้ง'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the error dialog
                                    },
                                    child: Text('ตกลง'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('เสร็จสิ้น'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void editCategory(BuildContext context, Map<String, dynamic> category,
      int categoriesIndex) {
    final GlobalKey<FormState> _categoryEditFormKey = GlobalKey<FormState>();

    TextEditingController editedCategoryTitleController =
        TextEditingController(text: category['category_title']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แก้ไขประเภทท็อปปิ้ง'),
          content: Form(
            key: _categoryEditFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(editedCategoryTitleController, "ชื่อท็อปปิ้ง",
                    TextInputType.name),
                ElevatedButton(
                  onPressed: () {
                    if (_categoryEditFormKey.currentState!.validate()) {
                      setState(() {
                        categories[categoriesIndex]['category_title'] =
                            editedCategoryTitleController.text;
                      });
                      Navigator.of(context).pop(); // Close the edit dialog
                    }
                  },
                  child: Text("บันทึกการแก้ไข"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void editOptions(BuildContext context, Map<String, dynamic> category,
      int categoriesIndex, int optionIndex) {
    final GlobalKey<FormState> _optionsEditFormKey = GlobalKey<FormState>();

    TextEditingController editedOptionTitleController = TextEditingController(
        text: category['options'][optionIndex]['option_title']);
    TextEditingController editedOptionPriceController = TextEditingController(
        text: category['options'][optionIndex]['option_price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แก้ไขรายการท็อปปิ้ง'),
          content: Form(
            key: _optionsEditFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(editedOptionTitleController, "ชื่อท็อปปิ้ง",
                    TextInputType.name),
                buildTextField(editedOptionPriceController, "ราคาท็อปปิ้ง",
                    TextInputType.number),
                ElevatedButton(
                  onPressed: () {
                    if (_optionsEditFormKey.currentState!.validate()) {
                      setState(() {
                        categories[categoriesIndex]['options'][optionIndex]
                            ['option_title'] = editedOptionTitleController.text;
                        categories[categoriesIndex]['options'][optionIndex]
                                ['option_price'] =
                            double.parse(editedOptionPriceController.text);
                      });
                      Navigator.of(context).pop(); // Close the edit dialog
                    }
                  },
                  child: Text("บันทึกการแก้ไข"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openEditing(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: cMainColor,
              title: Text('ประเภทท็อปปิ้ง'),
              automaticallyImplyLeading: false,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final value = categories[index];
                  List options = value['options'];

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'ชื่อประเภทท็อปปิ้ง: ${value['category_title']}'),
                                IconButton(
                                    onPressed: () {
                                      // Handle editing here
                                      editCategory(context, value, index);
                                    },
                                    icon: Icon(Icons.edit)),
                              ],
                            ),
                            Column(
                              children: options.asMap().entries.map((option) {
                                final optionindex = option.key;
                                final optionvalue = option.value;

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'ชื่อท็อปปิ้ง: ${optionvalue['option_title']}'),
                                        Text(
                                            'ราคาท็อปปิ้ง: ฿ ${optionvalue['option_price']}'),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          // Handle editing here
                                          editOptions(context, value, index,
                                              optionindex);
                                        },
                                        icon: Icon(Icons.edit)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                childCount: categories.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดกรอก${label}';
        }
        return null; // คืนค่า null เมื่อไม่มีข้อผิดพลาด
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: cMainColor,
          elevation: 0.0,
        ),
        body: Form(
          key: _formKey,
          child: Column(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Noom Nim',
                            textAlign: TextAlign.center,
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
                padding: const EdgeInsets.all(defaultPadding),
                child: const Text(
                  'รายการอาหารที่ต้องการเพิ่ม',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.03,
                          ),
                          child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            onTap: () async {
                              final imageFile =
                                  await ImageProfileHelper().pickImage();
                              if (imageFile != null) {
                                final croppedFile =
                                    await ImageProfileHelper().crop(
                                  file: imageFile,
                                  cropStyle: CropStyle.rectangle,
                                );
                                if (croppedFile != null) {
                                  setState(() {
                                    _image = File(croppedFile.path);
                                    _hasImage = true;
                                  });
                                }
                              }
                            },
                            child: Container(
                              width: 144,
                              height: 144,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape
                                    .rectangle, // กำหนดรูปร่างเป็นสี่เหลี่ยม
                              ),
                              child: _hasImage == true
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(_image!,
                                          fit: BoxFit.cover),
                                    )
                                  : Icon(Icons.add_a_photo,
                                      size: 72, color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        buildTextField(menuTitleController, "ชื่อเมนู",
                            TextInputType.name),
                        buildTextField(
                          menuPriceController,
                          "ราคา",
                          TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: openCreateCategoryDialog,
                              child: Text("เพิ่มท็อปปิ้ง"),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  categories.clear();
                                });
                              },
                              child: Text("ล้างท็อปปิ้ง"),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (categories.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('คุณยังไม่ได้ใส่ท็อปปิ้ง'),
                                      duration: Duration(
                                          seconds:
                                              3), // ระยะเวลาที่แจ้งเตือนแสดง
                                    ),
                                  );
                                } else {
                                  openEditing(context);
                                }
                              },
                              child: Text("แก้ไขท็อปปิ้ง"),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: cMainColor,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _hasImage) {
                      createMenuData();
                    } else if (!_hasImage &&
                        _formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('โปรดเลือกรูปภาพอาหาร'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(200, 48),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(cMainColor),
                  ),
                  child: Text(
                    'สร้างเมนู'.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
