import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';
import '../models/order.dart' as my_order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_history_screen.dart'; // Import OrderHistoryScreen
import 'home_screen.dart'; // Import home screen

class CartContent extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(Drink, int, String) onUpdateQuantity;
  final VoidCallback onRemoveItem;

  CartContent({
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  State<CartContent> createState() => _CartContentState();
}

class _CartContentState extends State<CartContent> {
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập địa chỉ nhận hàng.')),
      );
      return;
    }
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giỏ hàng của bạn đang trống.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bạn chưa đăng nhập.')),
          );
        }
        return;
      }

      my_order.Order newOrder = my_order.Order(
        orderId: '',
        userId: user.uid,
        items: widget.cartItems,
        totalPrice: widget.cartItems.fold<double>(
            0.0,
            (sum, item) =>
                sum + item.drink.getPriceForSize(item.size) * item.quantity),
        address: _addressController.text,
        orderDate: Timestamp.now(),
        status: 'Đang xử lý',
      );

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('orders')
          .add(newOrder.toFirestore());

      await docRef.update({'orderId': docRef.id});


      // Don't navigate here. Show the dialog instead.
      if(mounted){
          _showOrderSuccessDialog(context, docRef.id); // Show the dialog
      }
      widget.onRemoveItem(); // Clear the cart *after* saving

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đặt hàng: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

    void _showOrderSuccessDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(24), // Add padding
          shape: RoundedRectangleBorder( // Rounded corners
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Important for dynamic content
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                "Đặt hàng thành công!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Đơn hàng của bạn đã được ghi nhận.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Mã đơn hàng: $orderId", // Display the order ID
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Row( // Use a Row for side-by-side buttons
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space them evenly
                children: [
                    ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Use a different color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                         shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(  // Use pushReplacement
                        context,
                        MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
                      );
                    },
                    child: Text("Xem lịch sử", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                       shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))
                    ),
                    onPressed: () {
                        Navigator.of(context).pop(); // pop dialog
                        Navigator.of(context).pop(); // pop cart screen to return homescreen

                    },
                    child: Text("Tiếp tục ",style: TextStyle(color: Colors.white),),
                  ),

                ],
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (var item in widget.cartItems) {
      totalPrice += item.drink.getPriceForSize(item.size) * item.quantity;
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = widget.cartItems[index];
              return _buildCartItem(cartItem, index, context);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ nhận hàng',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ nhận hàng.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.cartItems.length} Items'),
                  Text(
                    '${totalPrice.toStringAsFixed(0)} VNĐ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _isLoading ? CircularProgressIndicator() : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: _placeOrder,
                child: Text(
                  'Đặt Hàng',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem cartItem, int index, BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cartItem.drink.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.drink.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Size: ${cartItem.size}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${cartItem.drink.getPriceForSize(cartItem.size).toStringAsFixed(0)} VNĐ',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (cartItem.quantity > 1) {
                      widget.onUpdateQuantity(
                          cartItem.drink, cartItem.quantity - 1, cartItem.size);
                    } else {
                      widget.onUpdateQuantity(
                          cartItem.drink, 0, cartItem.size); // Xóa
                    }
                  },
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    widget.onUpdateQuantity(
                        cartItem.drink, cartItem.quantity + 1, cartItem.size);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(Drink, int, String) onUpdateQuantity;
  final VoidCallback onRemoveItem;

  CartScreen({
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black),
            onPressed: onRemoveItem, // Không gọi trực tiếp, chỉ truyền hàm
          ),
        ],
      ),
      body: CartContent(
        cartItems: cartItems,
        onUpdateQuantity: onUpdateQuantity,
        onRemoveItem: onRemoveItem,
      ),
    );
  }
}