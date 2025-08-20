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
          return Scaffold(
            appBar: AppBar(
                leading: BackButton(onPressed: () => Navigator.pop(context))),
            body: const Center(child: Text('상품을 찾을 수 없습니다.')),
          );
        }

        // 화면
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('상품 상세'),
            // 상단 우측 아이콘은 사용하지 않음(하단 하트 사용)
            actions: const [],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1) 상단 큰 이미지
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    'assets/images/${p.imageFile}',
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 12),

                // 2) 판매자 카드(좌: 프로필/닉네임/주소, 우: 매너온도)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.seller,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(
                                p.address,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // 우측 매너온도
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '39.3 ℃',
                              style: TextStyle(
                                color: Colors.teal.shade400,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Column(
                              children: [
                                Text(
                                  '매너온도',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    height: 0,
                                  ),
                                ),
                                Container(
                                  height: 0.4,
                                  width: 45,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),

                // 3) 제목/내용
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        p.description, // '\n' 문구 제거했다면 그대로 사용
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4) 하단 고정 바 (좌 하트 / 가운데 가격 / 우 채팅 버튼)
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  // 하트 토글
                  IconButton(
                    onPressed: () => vm.toggleLike(p.id),
                    icon: Icon(
                      p.liked ? Icons.favorite : Icons.favorite_border,
                      color: p.liked ? Colors.red : Colors.grey.shade700,
                    ),
                  ),
                  // 가운데 가격 (가운데 정렬 느낌 나도록 Expanded 사용)
                  Expanded(
                    child: Center(
                      child: Text(
                        _price(p.price),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  // 채팅 버튼
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8A3D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
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
