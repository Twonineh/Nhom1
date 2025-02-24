// lib/models/order.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';
import 'drink.dart'; // Add this line to import the Drink class

class Order {
  final String orderId;
  final String userId;
  final List<CartItem> items;
  final double totalPrice;
  final String address;
  final Timestamp orderDate; // Sử dụng Timestamp của Firestore
  final String status;      // Thêm trạng thái đơn hàng

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.address,
    required this.orderDate,
    required this.status,

  });

  // Chuyển từ Firestore Document sang đối tượng Order
  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> itemsData = data['items'];

    List<CartItem> itemsList = itemsData.map((itemData) {

      return CartItem(
        drink: Drink( // Tạo Drink object từ dữ liệu
          id: itemData['drink']['id'],
          name: itemData['drink']['name'],
          description: itemData['drink']['description'],
          prices: Map<String, dynamic>.from(itemData['drink']['prices']), // Chuyển Map<dynamic, dynamic> sang Map<String, dynamic>
          imageUrl: itemData['drink']['imageUrl'],
          category: itemData['drink']['category'],

        ),
        quantity: itemData['quantity'],
        size: itemData['size'],
      );
    }).toList();

    return Order(
      orderId: doc.id,
      userId: data['userId'],
      items: itemsList,
      totalPrice: (data['totalPrice'] as num).toDouble(), // Ép kiểu về double
      address: data['address'],
      orderDate: data['orderDate'],
      status: data['status'] ?? 'Đang xử lý', // Đặt giá trị mặc định
    );
  }

    // Chuyển từ đối tượng Order sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => {  // Chuyển List<CartItem> sang List<Map>
        'drink': { // Lưu thông tin Drink
          'id': item.drink.id,
          'name': item.drink.name,
          'description': item.drink.description,
          'prices' : item.drink.prices,
          'imageUrl': item.drink.imageUrl,
          'category':item.drink.category,
        },
        'quantity': item.quantity,
        'size': item.size,
      }).toList(),
      'totalPrice': totalPrice,
      'address': address,
      'orderDate': orderDate, // Lưu Timestamp
      'status': status,
    };
  }
}