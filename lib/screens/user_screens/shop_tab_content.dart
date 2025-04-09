import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user_screens/productiondetail_screen.dart';

class ShopTabContent extends StatefulWidget {
  @override
  _ShopTabContentState createState() => _ShopTabContentState();
}

class _ShopTabContentState extends State<ShopTabContent> {
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả'; // Danh mục mặc định

  // Danh sách sản phẩm mẫu (có thể thay bằng dữ liệu từ API)
  final List<Map<String, String>> _products = [
    {
      'title': 'Găng tay tập gym',
      'price': '250.000 VNĐ',
      'image': 'assets/gloves.jpg',
      'category': 'Phụ kiện',
      'description': 'Găng tay tập gym chất liệu cao cấp, chống trơn trượt, hỗ trợ bảo vệ tay khi tập luyện.',
    },
    {
      'title': 'Dây kháng lực',
      'price': '150.000 VNĐ',
      'image': 'assets/resistance_band.png',
      'category': 'Phụ kiện',
      'description': 'Dây kháng lực đa năng, phù hợp cho các bài tập tại nhà hoặc phòng gym.',
    },
    {
      'title': 'Áo tập gym',
      'price': '300.000 VNĐ',
      'image': 'assets/shirt.jpg',
      'category': 'Quần áo',
      'description': 'Áo tập gym thoáng khí, thấm hút mồ hôi, phù hợp cho mọi loại hình tập luyện.',
    },
    {
      'title': 'Giày thể thao',
      'price': '1.200.000 VNĐ',
      'image': 'assets/shoes.jpg',
      'category': 'Giày',
      'description': 'Giày thể thao thời trang, đế chống trượt, hỗ trợ vận động tối ưu.',
    },
  ];

  // Danh sách danh mục
  final List<String> _categories = ['Tất cả', 'Phụ kiện', 'Quần áo', 'Giày'];

  @override
  Widget build(BuildContext context) {
    // Lọc sản phẩm dựa trên tìm kiếm và danh mục
    final filteredProducts = _products.where((product) {
      final matchesSearch =
          product['title']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Tất cả' || product['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm sản phẩm...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          SizedBox(height: 16),
          // Danh mục sản phẩm
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          _selectedCategory == category ? Colors.white : Colors.black,
                      backgroundColor:
                          _selectedCategory == category ? Colors.blue : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(category),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          // Danh sách sản phẩm
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.65,
              children: filteredProducts.map((product) {
                return _buildShopItem(
                  context: context,
                  title: product['title']!,
                  price: product['price']!,
                  image: product['image']!,
                  description: product['description']!,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem({
    required BuildContext context,
    required String title,
    required String price,
    required String image,
    required String description,
  }) {
    return InkWell(
      onTap: () {
        // Chuyển sang trang chi tiết sản phẩm khi nhấn
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              title: title,
              price: price,
              image: image,
              description: description,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$title đã được thêm vào giỏ hàng')),
                      );
                    },
                    icon: Icon(Icons.add_shopping_cart, size: 18),
                    label: Text('Thêm'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 36),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}