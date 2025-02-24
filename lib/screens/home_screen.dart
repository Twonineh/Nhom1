import 'package:flutter/material.dart';
import 'menu_screen.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart'; // Import OrderHistoryScreen
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'all';
  List<CartItem> _cartItems = [];

  // ... (các hàm addToCart, updateCartItemQuantity, clearCart giữ nguyên) ...
  void _addToCart(Drink drink, int quantity, String size) {
    int existingIndex = _cartItems
        .indexWhere((item) => item.drink.id == drink.id && item.size == size);

    if (existingIndex >= 0) {
      setState(() {
        _cartItems[existingIndex].quantity += quantity;
      });
    } else {
      Drink newDrink = Drink(
        id: drink.id,
        name: drink.name,
        description: drink.description,
        prices: {size: drink.getPriceForSize(size)},
        imageUrl: drink.imageUrl,
        category: drink.category,
      );
      setState(() {
        _cartItems.add(CartItem(drink: newDrink, quantity: quantity, size: size));
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm ${drink.name} vào giỏ hàng')),
    );
  }

  void _updateCartItemQuantity(Drink drink, int newQuantity, String size) {
    int index = _cartItems
        .indexWhere((item) => item.drink.id == drink.id && item.size == size);
    if (index >= 0) {
      setState(() {
        if (newQuantity <= 0) {
          _cartItems.removeAt(index);
        } else {
          _cartItems[index].quantity = newQuantity;
        }
      });
    }
  }

    void _clearCart() {
    setState(() {
      _cartItems = [];
    });
  }


  List<Widget> _buildPages() {
    return [
      // HOME PAGE
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBanner(),
          // ... (phần còn lại của trang home giữ nguyên) ...
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Các Loại Đồ Uống',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  _buildCategoryButton('All'),
                  SizedBox(width: 8),
                  _buildCategoryButton('Coffee'),
                  SizedBox(width: 8),
                  _buildCategoryButton('Tea'),
                  SizedBox(width: 8),
                  _buildCategoryButton('Fruits Juice'),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đồ Uống',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

              ],
            ),
          ),
          Expanded(
            child: MenuScreen(
              selectedCategory: _selectedCategory,
              onAddToCart: _addToCart,
              cartItems: _cartItems,
              onUpdateQuantity: _updateCartItemQuantity,
              onRemoveItem:
                  _clearCart, // Pass the correct function to clear the cart
            ),
          ),
        ],
      ),
      CartContent(
        cartItems: _cartItems,
        onUpdateQuantity: _updateCartItemQuantity,
        onRemoveItem: _clearCart, // Pass the correct function here
      ),
      UserProfileScreen(),
      OrderHistoryScreen(), // Thay thế bằng OrderHistoryScreen
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      // Không cần xử lý trường hợp index == 3 nữa
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
          },
        ),
        title: Text(
          'Coffee Topaz',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10)
        ],
      ),
      body: _buildPages()[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
            BottomNavigationBarItem(    // Thay đổi icon
                icon: Icon(Icons.history), label: 'Order History'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category.toLowerCase();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedCategory.toLowerCase() == category.toLowerCase()
              ? Colors.orange
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedCategory.toLowerCase() == category.toLowerCase()
                ? Colors.orange
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: _selectedCategory.toLowerCase() == category.toLowerCase()
                ? Colors.white
                : Colors.black,
            fontWeight: _selectedCategory.toLowerCase() == category.toLowerCase()
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
              'https://img.freepik.com/free-vector/online-food-delivery-banner_1262-19630.jpg'), // Replace with your image URL
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The Fastest In\nDelivery Drink',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            child: Text(
              'Đặt Hàng',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}