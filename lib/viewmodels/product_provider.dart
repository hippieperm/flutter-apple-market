import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repo;
  ProductProvider(this._repo);

  List<Product> _items = [];
  bool _loading = true;

  List<Product> get items => _items;
  bool get loading => _loading;

  Future<void> loadProducts() async {
    _loading = true;
    notifyListeners();
    _items = await _repo.load();
    _loading = false;
    notifyListeners();
  }

  Product? getById(int id) {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  void toggleLike(int id) {
    final p = getById(id);
    if (p == null) return;
    p.liked = !p.liked;
    if (p.liked) {
      p.likes += 1;
    } else {
      p.likes = (p.likes - 1).clamp(0, 1 << 31);
    }
    notifyListeners();
  }

  void deleteAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void deleteById(int id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
