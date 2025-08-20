import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_provider.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.productId});
  final int productId;

  String _price(int v) => '${NumberFormat('#,###').format(v)}원';

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, vm, _) {
        final Product? p = vm.getById(productId);
        if (p == null) {
          // 삭제 후 돌아왔을 때 등
          return Scaffold(
            appBar: AppBar(
                leading: BackButton(onPressed: () => Navigator.pop(context))),
            body: const Center(child: Text('상품을 찾을 수 없습니다.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('상품 상세'),
            actions: [
              IconButton(
                onPressed: () => vm.toggleLike(p.id),
                icon: Icon(
                  p.liked ? Icons.favorite : Icons.favorite_border,
                  color: p.liked ? Colors.red : null,
                ),
                tooltip: '좋아요',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/${p.imageFile}',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.seller,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            Text(p.address,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('♥ ${p.likes}',
                          style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(p.description,
                          style: const TextStyle(fontSize: 15, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Text(_price(p.price),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('채팅하기'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
