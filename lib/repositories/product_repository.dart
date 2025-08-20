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

      items.add(
        Product(
          id: parseInt(row[0]),
          imageFile: row[1].toString().trim(),
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
