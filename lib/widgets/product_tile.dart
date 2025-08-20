import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onLongPress,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  String get priceText => '${NumberFormat('#,###').format(product.price)} 원';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/${product.imageFile}',
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.address,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          priceText,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 16),
                            const SizedBox(width: 3),
                            Text('${product.chats}',
                                style: TextStyle(color: Colors.grey.shade700)),
                            const SizedBox(width: 10),
                            Icon(
                              product.liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: product.liked ? Colors.red : null,
                            ),
                            const SizedBox(width: 3),
                            Text('${product.likes}',
                                style: TextStyle(color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
