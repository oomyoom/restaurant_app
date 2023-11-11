import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getAllOrder() async {
  final response = await http.get(
    Uri.parse('http://192.168.1.84:3333/order/allorder'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> allOrder = json.decode(response.body);
    return allOrder;
  } else {
    // กรณีเกิดข้อผิดพลาดในการรับข้อมูล
    return [];
  }
}

Future<List<dynamic>> getAllTransaction() async {
  final response = await http.get(
    Uri.parse('http://192.168.1.84:3333/order/transaction'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> allTransaction = json.decode(response.body);
    return allTransaction;
  } else {
    // กรณีเกิดข้อผิดพลาดในการรับข้อมูล
    return [];
  }
}

Future<List<dynamic>> getAllTransactionThisWeek() async {
  final response = await http.get(
    Uri.parse('http://192.168.1.84:3333/order/transaction/week'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> allTransaction = json.decode(response.body);
    return allTransaction;
  } else {
    // กรณีเกิดข้อผิดพลาดในการรับข้อมูล
    return [];
  }
}

Future<List<dynamic>> getAllTransactionThisDay() async {
  final response = await http.get(
    Uri.parse('http://192.168.1.84:3333/order/transaction/day'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> allTransaction = json.decode(response.body);
    return allTransaction;
  } else {
    // กรณีเกิดข้อผิดพลาดในการรับข้อมูล
    return [];
  }
}

Future<List<dynamic>> getAllTransactionThisMonth() async {
  final response = await http.get(
    Uri.parse('http://192.168.1.84:3333/order/transaction/month'),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> allTransaction = json.decode(response.body);
    return allTransaction;
  } else {
    // กรณีเกิดข้อผิดพลาดในการรับข้อมูล
    return [];
  }
}

class Order2 {
  bool isCompleted;
  bool isRecieved;

  final int orderId;
  final List<CartItem2> orderItems;
  final int totalPrice;
  final DateTime creatDateTime;
  final String deliveryOption, phonenumber;

  Order2(
      {required this.orderId,
      required this.orderItems,
      required this.totalPrice,
      required this.creatDateTime,
      required this.deliveryOption,
      required this.phonenumber,
      this.isCompleted = false,
      this.isRecieved = false});
}

class CartItem2 {
  final Menu3 foodItem;
  int priceItem, specfiyPrice;
  String specifyItem;
  int quantity;

  CartItem2(
      {required this.foodItem,
      required this.quantity,
      required this.priceItem,
      required this.specifyItem,
      required this.specfiyPrice});
}

class Menu3 {
  final int id;
  final String title;
  final List<int> image;
  final int price;

  Menu3({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });
}

Future<List<dynamic>> convertAllOrder(List<dynamic> orderData) async {
  orderData = orderData.map((e) {
    List<Map<String, dynamic>> cartData =
        (e['cart'] as List).cast<Map<String, dynamic>>();

    List<CartItem2> cart = cartData.map(
      (cart) {
        String optionItem = cart['option_item'];
        int optionTotal = cart['option_total'];
        int cartTotal = cart['cart_total'];
        int cartQty = cart['cart_qty'];

        int menuId = cart['menu']['menu_id'];
        String menuTitle = cart['menu']['menu_title'];
        int menuPrice = cart['menu']['menu_price'];
        List<int> menuImage =
            (cart['menu']['menu_image']['data'] as List).cast<int>();

        return CartItem2(
            foodItem: Menu3(
              id: menuId,
              title: menuTitle,
              image: menuImage,
              price: menuPrice,
            ),
            quantity: cartQty,
            priceItem: cartTotal,
            specifyItem: optionItem,
            specfiyPrice: optionTotal);
      },
    ).toList();

    return Order2(
        orderId: e['order_id'],
        orderItems: cart,
        totalPrice: e['order_total'],
        creatDateTime: DateTime.parse(e['createDateTime']).toLocal(),
        deliveryOption: e['deliveryOption'],
        phonenumber: e['phonenumber'],
        isCompleted: (e['isCompleted'] == 1),
        isRecieved: (e['isRecieved'] == 1));
  }).toList();
  return orderData;
}
