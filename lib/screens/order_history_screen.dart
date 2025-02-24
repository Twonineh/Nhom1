// lib/screens/order_history_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/order.dart' as my_order; // Add 'as my_order'
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("Bạn chưa đăng nhập."));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử đơn hàng"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('orderDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Có lỗi xảy ra: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Bạn chưa có đơn hàng nào."));
          }

          List<my_order.Order> orders = snapshot.data!.docs  // Use my_order.Order
              .map((doc) => my_order.Order.fromFirestore(doc)) // Use my_order.Order
              .toList();

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildOrderItem(context, orders[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, my_order.Order order) { // Use my_order.Order
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text("Đơn hàng #${order.orderId}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ngày đặt: ${order.orderDate.toDate().toLocal()}"),
            Text("Trạng thái: ${order.status}"),
            Text("Tổng: ${order.totalPrice.toStringAsFixed(0)} VNĐ"),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: order),
            ),
          );
        },
      ),
    );
  }
}