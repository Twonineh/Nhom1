# Project Name: Dự án quản lý quán cafe

# Project Members
```
Nguyễn Thế Anh
Bùi Trung Đức
Lệ Thu Nguyễn

```
#Mục tiêu dự án Android quản lý quán cafe:
###Tối ưu hóa quản lý hoạt động quán cafe:
-Tự động hóa quy trình từ quản lý bàn, hóa đơn đến kiểm soát hàng hóa và tồn kho, giúp tiết kiệm thời gian và giảm sai sót trong quản lý.

###Cải thiện trải nghiệm khách hàng:
-Hỗ trợ nhân viên xử lý yêu cầu đặt bàn, gọi món nhanh chóng, giảm thời gian chờ đợi, từ đó nâng cao sự hài lòng của khách hàng.

###Quản lý thông tin người dùng:
-Cung cấp hệ thống đăng nhập bảo mật, quản lý thông tin cá nhân và phân quyền vai trò cho các nhân viên và quản lý quán.

###Tăng cường hiệu quả kinh doanh:
-Theo dõi báo cáo doanh thu, trạng thái bàn, và thông tin chi tiết hóa đơn để hỗ trợ ra quyết định kinh doanh nhanh chóng và chính xác.

###Thông báo và tương tác nội bộ:
-Cung cấp chức năng tạo và quản lý thông báo giúp truyền đạt thông tin quan trọng tới nhân viên và quản lý một cách hiệu quả.

###Khả năng mở rộng và tích hợp:
-Đảm bảo hệ thống có khả năng tích hợp với các nền tảng thanh toán điện tử, hệ thống in hóa đơn, và hỗ trợ các tính năng mở rộng trong tương lai như đặt món qua app di động.
#Phương thức hoạt động
###Người Dùng (NguoiDung):
-Người dùng đăng nhập vào hệ thống thông qua phương thức 'login()' để truy cập các chức năng phù hợp với vai trò của họ (nhân viên hoặc quản lý).
-Người dùng có thể cập nhật thông tin cá nhân bằng phương thức 'updateProfile()'.

###Quản lý bàn (Ban):
-Danh sách bàn trong quán cafe được quản lý thông qua đối tượng Ban, với trạng thái bàn (trangThai) được cập nhật bằng phương thức 'updateStatus()'.
-Khi có yêu cầu đặt món hoặc gọi bàn, phương thức 'assignOrder()' được sử dụng để chỉ định đơn hàng cho bàn tương ứng.

###Hàng hóa và loại hàng (HangHoa, LoaiHang):
-Các sản phẩm được tổ chức theo danh mục (LoaiHang), và các danh mục này có thể được thêm hoặc chỉnh sửa thông qua phương thức 'addProduct()' và 'updateCategory()'.
-Thông tin về sản phẩm, bao gồm giá và trạng thái (còn hàng hoặc hết hàng), được cập nhật thông qua các phương thức như 'updatePrice()' và 'changeStatus()'.

###Hóa đơn và chi tiết hóa đơn (HoaDon, HoaDonChiTiet):
-Khi khách hàng vào quán, hóa đơn mới được tạo thông qua phương thức 'createInvoice()', lưu lại thời điểm vào bàn (gioVao) và trạng thái hóa đơn (trangThai).
-Các mặt hàng được thêm hoặc xóa khỏi hóa đơn bằng phương thức 'addItem()' hoặc 'removeItem()' của đối tượng HoaDonChiTiet.
-Khi khách rời đi, hóa đơn được đóng và trạng thái cập nhật qua phương thức 'closeInvoice()'.

###Thông báo (ThongBao):
-Thông báo được tạo bởi quản trị viên hoặc hệ thống thông qua phương thức 'createNotification()' để thông báo cho người dùng về các sự kiện, thông tin quan trọng.
-Người dùng có thể đánh dấu thông báo đã đọc thông qua phương thức 'markAsRead()'.

###Mối quan hệ giữa các đối tượng:
-Người dùng liên quan đến các hóa đơn (HoaDon), thông qua các thao tác tạo và quản lý hóa đơn.
-Mỗi hóa đơn chứa các chi tiết cụ thể (HoaDonChiTiet) về sản phẩm được gọi và các ghi chú.
-Các thông báo (ThongBao) được liên kết với người dùng để đảm bảo thông tin được truyền đạt kịp thời.
