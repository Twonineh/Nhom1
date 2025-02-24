import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../screens/drink_detail_screen.dart';
import '../models/cart_item.dart';

class DrinkItem extends StatefulWidget {
  final Drink drink;
  final Function(Drink, int, String) onAddToCart;
  final List<CartItem> cartItems; // ADDED
    final Function(Drink, int, String) onUpdateQuantity;  // ADDED
  final VoidCallback onRemoveItem; // ADDED

  DrinkItem({
    required this.drink,
    required this.onAddToCart,
    required this.cartItems, // ADDED
    required this.onUpdateQuantity, //ADDED
    required this.onRemoveItem //ADDED
  });

  @override
  State<DrinkItem> createState() => _DrinkItemState();
}

class _DrinkItemState extends State<DrinkItem> {
  int _quantity = 1;
  String _selectedSize = "M";

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showDrinkDetails(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  widget.drink.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.drink.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Phổ Biến',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${widget.drink.getPriceForSize("M").toStringAsFixed(0)} VNĐ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(onTap: () {}, child: Icon(Icons.favorite_border)),
            )
          ],
        ),
      ),
    );
  }

  void _showDrinkDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.drink.imageUrl,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setModalState(() {
                            if (_quantity > 1) {
                              _quantity--;
                            }
                          });
                        },
                      ),
                      Text('$_quantity', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setModalState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.drink.name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.drink.getPriceForSize(_selectedSize).toStringAsFixed(0)} VNĐ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // Chọn size (Thêm phần này)
                    Text(
                    'Chọn Size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSizeOption('S', setModalState), // Truyền setModalState
                      SizedBox(width: 8),
                      _buildSizeOption('M', setModalState),
                      SizedBox(width: 8),
                      _buildSizeOption('L', setModalState),
                    ],
                  ),

                  // SizedBox(height: 16), // Bỏ các phần không cần thiết
                  // Text(
                  //   "Mix Cream", // Bỏ dòng này
                  //   style: TextStyle(fontSize: 16, color: Colors.grey),
                  // ),
                  // SizedBox(height: 16), // Bỏ
                  // Row( // Bỏ
                  //   children: [
                  //     Icon(Icons.star, color: Colors.amber, size: 20),
                  //     Text(' 4.7', style: TextStyle(fontSize: 14)),
                  //     SizedBox(width: 16),
                  //     Icon(Icons.local_fire_department,
                  //         color: Colors.orange, size: 20),
                  //     Text(' 150k', style: TextStyle(fontSize: 14)),
                  //     SizedBox(width: 16),
                  //     Icon(Icons.timer, color: Colors.grey, size: 20),
                  //     Text(' 10-15Min', style: TextStyle(fontSize: 14)),
                  //   ],
                  // ),
                  // SizedBox(height: 16), // Bỏ
                  // Text(
                  //     "This is a special types of items, often served with cheese, lettuce, tomato, onion, pickles, bacon, or chilis;... Read More",
                  //      style: TextStyle(fontSize: 15)), // Bỏ mô tả dài
                  // SizedBox(height: 24),

                  SizedBox(height: 24), // Giữ khoảng cách
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      minimumSize:
                          Size(double.infinity, 50), // Full width button
                    ),
                    onPressed: () {
                      widget.onAddToCart(widget.drink, _quantity, _selectedSize); // Thêm size
                      Navigator.pop(context); // Close modal
                    },
                    child: Text('Thêm vào giỏ hàng',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DrinkDetailScreen(
                              drink: widget.drink,
                              onAddToCart: widget.onAddToCart,
                               cartItems: widget.cartItems,
                               onUpdateQuantity: widget.onUpdateQuantity,
                               onRemoveItem: widget.onRemoveItem
                            ),
                          ),
                        );
                      },
                      child: Text('Chi Tiết',
                          style: TextStyle(color: Colors.blue, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
// Hàm hỗ trợ build các lựa chọn size.
    Widget _buildSizeOption(String size, StateSetter setModalState) {
    return InkWell(
      onTap: () {
        setModalState(() {  // Dùng setModalState để cập nhật UI trong modal
          _selectedSize = size;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _selectedSize == size ? Colors.orange : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: _selectedSize == size ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}