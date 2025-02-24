import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/drink.dart';
import '../widgets/drink_item.dart';
import 'drink_detail_screen.dart';
import '../models/cart_item.dart';

class MenuScreen extends StatefulWidget {
  final String selectedCategory;
  final Function(Drink, int, String) onAddToCart;
  final List<CartItem> cartItems;
  final Function(Drink, int, String) onUpdateQuantity;
  final VoidCallback onRemoveItem;

  MenuScreen({
    required this.selectedCategory,
    required this.onAddToCart,
    required this.cartItems,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final CollectionReference _drinksCollection =
      FirebaseFirestore.instance.collection('Drinks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _drinksCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Không có đồ uống nào.'));
        }

        List<Drink> drinksToShow = snapshot.data!.docs.map((doc) {
          return Drink.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        if (widget.selectedCategory.isNotEmpty &&
            widget.selectedCategory.toLowerCase() != "all") {
          drinksToShow = drinksToShow
              .where((drink) =>
                  drink.category.toLowerCase() ==
                  widget.selectedCategory.toLowerCase())
              .toList();
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            double itemWidth =
                (constraints.maxWidth - (16 * 3)) / 2.5; // No change here

            return GridView.builder( // Changed to GridView.builder
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,       // Number of columns: 2
                childAspectRatio: itemWidth / (itemWidth + 85), // Adjust as needed.
                mainAxisSpacing: 16,    // Vertical spacing
                crossAxisSpacing: 16,   // Horizontal spacing
              ),
              padding: EdgeInsets.all(16),
              itemCount: drinksToShow.length,
              itemBuilder: (context, index) {
                return DrinkItem(  // No Container or width needed here
                  drink: drinksToShow[index],
                  onAddToCart: widget.onAddToCart,
                  cartItems: widget.cartItems,
                  onUpdateQuantity: widget.onUpdateQuantity,
                  onRemoveItem: widget.onRemoveItem,
                );
              },
            );
          },
        );
      },
    );
  }
}