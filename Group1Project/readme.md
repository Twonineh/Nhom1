## Code chính của class User
- class User {
  final String username;
  final String password;
  final String role;

  User({required this.username, required this.password, required this.role});
## Code chính Object của class User
### Object của class User được khởi tạo trong hàm _showAddUserDialog()
- final user = User(
    username: usernameController.text,
    password: passwordController.text,
    role: roleController.text,
  );
