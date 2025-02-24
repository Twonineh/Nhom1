//lib/screens/order_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/order.dart' as my_order; // Add prefix here

class OrderDetailScreen extends StatelessWidget {
  final my_order.Order order; //Use prefix

  OrderDetailScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết đơn hàng #${order.orderId}"),
         backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ngày đặt: ${order.orderDate.toDate().toLocal()}", //Đã sửa
              style: TextStyle(fontSize: 16),
            ),
              Text(
              "Trạng thái: ${order.status}", //Đã sửa
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Địa chỉ: ${order.address}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Các món đã đặt:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return ListTile(
                  leading: Image.network(item.drink.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item.drink.name),
                  subtitle: Text('Size: ${item.size}, Số lượng: ${item.quantity}'),
                  trailing: Text(
                    '${(item.drink.getPriceForSize(item.size) * item.quantity).toStringAsFixed(0)} VNĐ',
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng cộng:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${order.totalPrice.toStringAsFixed(0)} VNĐ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}