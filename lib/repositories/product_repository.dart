import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> load() async {
    final raw =
        await rootBundle.loadString('assets/data/products.csv', cache: false);

    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(raw);

    final items = <Product>[];

    for (final row in rows) {
      if (row.isEmpty) continue;

      final first = row.first.toString().trim();
      if (first.isEmpty || first.startsWith('/') || first == '번호') continue;

      if (row.length < 9) continue;

      int parseInt(dynamic v) {
        final s = v.toString().replaceAll(RegExp(r'[^0-9\-]'), '');
        if (s.isEmpty) return 0;
        return int.tryParse(s) ?? 0;
      }

      String normalizeImage(dynamic v) {
        var img = v.toString().trim();
        // 경로만/파일명만 와도 처리. 확장자 없으면 png로 가정
        if (!img.contains('.')) img = '$img.png';
        // 혹시 assets/까지 들어온 값이면 파일명만 추출
        img = img.split('/').last;
        return img;
      }

      items.add(
        Product(
          id: parseInt(row[0]),
          imageFile: normalizeImage(row[1]),
          title: row[2].toString().trim(),
          description: row[3].toString().trim(),
          seller: row[4].toString().trim(),
          price: parseInt(row[5]),
          address: row[6].toString().trim(),
          likes: parseInt(row[7]),
          chats: parseInt(row[8]),
        ),
      );
    }

    return items;
  }
}
