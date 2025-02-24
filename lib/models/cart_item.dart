import '/models/drink.dart'; // Import Drink (Thay flutter_application_1 bằng tên app)

class CartItem {
  final Drink drink;
  int quantity;
  final String size; // Thêm size

  CartItem({
    required this.drink,
    required this.quantity,
    required this.size, // Thêm vào constructor
  });
}