// lib/models/drink.dart
class Drink {
  final String id; // Thêm ID
  final String name;
  final String description;
  final Map<String, dynamic> prices; // Sửa thành Map<String, dynamic>
  final String imageUrl;
  final String category;

  Drink({
    required this.id, // Thêm ID vào constructor
    required this.name,
    required this.description,
    required this.prices,
    required this.imageUrl,
    required this.category,
  });
  // Thêm phương thức để lấy giá theo size
  double getPriceForSize(String size) {
    return prices[size] ??
        0.0; // Trả về 0.0 hoặc giá mặc định nếu không tìm thấy size
  }

  factory Drink.fromFirestore(Map<String, dynamic> data, String id) {
    return Drink(
      id: id, // Gán ID
      name: data['name'],
      description: data['description'],
      prices:
          data['prices'] as Map<String, dynamic>, // Ép kiểu tường minh ở đây
      imageUrl: data['imageUrl'],
      category: data['category'],
    );
  }
}