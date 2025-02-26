# Project Name: Dự án quản lý quán cafe

# Project Members
```
Nguyễn Thế Anh
Bùi Trung Đức
Lệ Thu Nguyễn

```
# Mục tiêu dự án Android quản lý quán cafe:
### Tối ưu hóa quản lý hoạt động quán cafe:
- Tự động hóa quy trình từ quản lý bàn, hóa đơn đến kiểm soát hàng hóa và tồn kho, giúp tiết kiệm thời gian và giảm sai sót trong quản lý.

### Cải thiện trải nghiệm khách hàng:
- Hỗ trợ nhân viên xử lý yêu cầu đặt bàn, gọi món nhanh chóng, giảm thời gian chờ đợi, từ đó nâng cao sự hài lòng của khách hàng.

### Quản lý thông tin người dùng:
- Cung cấp hệ thống đăng nhập bảo mật, quản lý thông tin cá nhân và phân quyền vai trò cho các nhân viên và quản lý quán.

### Tăng cường hiệu quả kinh doanh:
- Theo dõi báo cáo doanh thu, trạng thái bàn, và thông tin chi tiết hóa đơn để hỗ trợ ra quyết định kinh doanh nhanh chóng và chính xác.

### Thông báo và tương tác nội bộ:
- Cung cấp chức năng tạo và quản lý thông báo giúp truyền đạt thông tin quan trọng tới nhân viên và quản lý một cách hiệu quả.

### Khả năng mở rộng và tích hợp:
- Đảm bảo hệ thống có khả năng tích hợp với các nền tảng thanh toán điện tử, hệ thống in hóa đơn, và hỗ trợ các tính năng mở rộng trong tương lai như đặt món qua app di động.
# Phương thức hoạt động
### Người Dùng (User):
Người dùng đăng ký tài khoản thông qua phương thức 'register()' để lưu thông tin cá nhân lên hệ thống.
Người dùng đăng nhập bằng phương thức 'login()' để truy cập các chức năng của ứng dụng.
Người dùng có thể cập nhật thông tin cá nhân qua phương thức 'updateProfile()'.
Người dùng đăng xuất khỏi hệ thống bằng phương thức 'logout()'.

### Đồ Uống (Drink):
Thông tin về đồ uống được lấy từ Firestore bằng phương thức 'fetchDrinks()'.
Người dùng có thể lọc đồ uống theo danh mục qua phương thức 'filterDrinks()'.
Giá theo kích cỡ của đồ uống được truy vấn qua phương thức 'getPriceForSize()'.

### Chi Tiết Đồ Uống (DrinkDetailScreen):
Khi người dùng chọn đồ uống, chi tiết đồ uống sẽ được hiển thị qua phương thức 'showDetails()'.
Người dùng có thể chọn kích cỡ, số lượng và thêm đồ uống vào giỏ hàng bằng phương thức 'addToCart()'.

### Màn Hình Chính (HomeScreen):
Xây dựng các trang chính (Menu, Giỏ hàng, Thông báo) bằng phương thức 'buildPages()'.
Xử lý sự kiện khi người dùng chọn menu dưới cùng qua phương thức 'onItemTapped()'.
Thêm đồ uống vào giỏ hàng bằng phương thức 'addToCart()'.
Cập nhật giỏ hàng khi có thay đổi bằng phương thức 'updateCart()'.
Xóa toàn bộ giỏ hàng thông qua phương thức 'clearCart()'.

### Giỏ Hàng (CartScreen):
Người dùng thay đổi số lượng sản phẩm qua phương thức 'onUpdateQty()'.
Người dùng có thể xóa sản phẩm khỏi giỏ qua phương thức 'onRemoveItem()'.

### Thông Báo (NotificationScreen):
Hiển thị thông báo cho người dùng thông qua phương thức 'build()'.

### Đăng Ký (RegisterScreen):
Người dùng nhập thông tin và đăng ký tài khoản bằng phương thức 'register()'.
Thông tin người dùng được lưu vào Firestore.

### Đăng Nhập (LoginScreen):
Người dùng đăng nhập vào hệ thống thông qua phương thức 'login()'.
Xác thực thông tin qua Firebase Authentication.

### Xác Thực (AuthScreen):
Hiển thị giao diện đăng nhập hoặc đăng ký qua phương thức 'showLogin()' và 'showRegister()'.

### Người Dùng Firebase (FirebaseAuth):
Tạo tài khoản mới qua phương thức 'createUserWithEmailAndPassword()'.
Đăng nhập qua phương thức 'signInWithEmailAndPassword()'.
Đăng xuất qua phương thức 'signOut()'.
Theo dõi trạng thái đăng nhập bằng phương thức 'authStateChanges()'.
Hồ Sơ Người Dùng (UserProfileScreen):
Lấy dữ liệu người dùng từ Firestore bằng phương thức 'getUserData()'.

### Đơn Hàng (Orders):
Đơn hàng mới được tạo và lưu vào Firestore qua phương thức 'createOrder()'.
Cập nhật trạng thái đơn hàng bằng phương thức 'updateOrderStatus()'.

### Cơ sở dữ liệu Firestore (Users, Orders):
Người dùng được lưu với các trường: uid, email, tên, số điện thoại, địa chỉ.
Đơn hàng lưu thông tin về người đặt, các mặt hàng, tổng tiền, ngày đặt, trạng thái đơn hàng.

# Sơ đồ Diagram của dự án
### Sơ đồ đăng nhập và chọn món
![Image](https://github.com/user-attachments/assets/a9774f2b-6ada-434c-a5bd-5a1078ede25f)

# Cấu trúc file code

# Giao diện app
![Image](https://github.com/user-attachments/assets/2ed424a4-aa56-498a-8706-41d76c2d7d83)

![Image](https://github.com/user-attachments/assets/cebd7f91-9817-49d8-9694-adc0ba1e00f2)

![Image](https://github.com/user-attachments/assets/516854af-c7f8-42fc-9733-5dec8dec0156)

![Image](https://github.com/user-attachments/assets/de237f91-511a-48b5-80a9-a83c76c46eb4)
