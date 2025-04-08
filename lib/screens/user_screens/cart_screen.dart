import 'package:flutter/material.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Giả sử đây là danh sách đã được thêm từ màn hình khác
  List<CartItem> cartItems = [
    CartItem(id: "1", name: "Dây đeo tay", type: "accessory", price: 50000, quantity: 2),
    CartItem(id: "2", name: "Gói tập 1 tháng", type: "package", price: 300000, quantity: 1),
    CartItem(id: "3", name: "Thuê PT 1 buổi", type: "pt", price: 200000, quantity: 1),
  ];

  void updateQuantity(int index, int change) {
    setState(() {
      cartItems[index].quantity += change;
      if (cartItems[index].quantity <= 0) {
        cartItems.removeAt(index);
      }
    });
  }

  double getTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Giỏ hàng",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Danh sách các mục trong giỏ hàng
          Expanded(
            child: cartItems.isEmpty
                ? Center(child: Text("Giỏ hàng trống", style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text("${item.price.toStringAsFixed(0)} VNĐ"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.blue),
                                onPressed: () => updateQuantity(index, -1),
                              ),
                              Text("${item.quantity}", style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.blue),
                                onPressed: () => updateQuantity(index, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Tổng tiền và nút thanh toán
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng tiền:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      "${getTotalPrice().toStringAsFixed(0)} VNĐ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          print("Thanh toán: ${getTotalPrice()} VNĐ");
                        },
                  child: Text("Thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}