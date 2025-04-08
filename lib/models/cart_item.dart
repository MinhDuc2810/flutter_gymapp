class CartItem {
  final String id; // ID duy nhất của sản phẩm/dịch vụ
  final String name; // Tên: ví dụ "Dây đeo tay", "Gói tập 1 tháng", "Thuê PT adina

  final String type; // Loại: "accessory", "package", "pt"
  final double price; // Giá
  int quantity; // Số lượng
  // Các thuộc tính khác nếu cần (ví dụ: thời gian thuê PT, mô tả, hình ảnh...)

  CartItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.quantity = 1,
  });
}