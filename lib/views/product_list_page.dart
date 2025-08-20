import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_provider.dart';
import '../widgets/product_tile.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _sc = ScrollController();
  var _showFab = false;
  var _fabPressedIconToggle = false;

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'ko_KR';
    // 스크롤 위치에 따라 FAB 표시
    _sc.addListener(() {
      final shouldShow = _sc.offset > 200;
      if (shouldShow != _showFab) {
        setState(() => _showFab = shouldShow);
      }
    });
    // 최초 로딩
    Future.microtask(() => context.read<ProductProvider>().loadProducts());
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  void _onBell() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('새 알림이 없습니다.')),
    );
  }

  Future<void> _confirmDelete(BuildContext ctx, int index, String title) async {
    final ok = await showDialog<bool>(
      context: ctx,
      builder: (dCtx) => AlertDialog(
        title: const Text('삭제하시겠어요?'),
        content: Text('"$title" 항목을 삭제합니다.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dCtx, false),
              child: const Text('취소')),
          TextButton(
              onPressed: () => Navigator.pop(dCtx, true),
              child: const Text('확인')),
        ],
      ),
    );
    if (ok == true && mounted) {
      context.read<ProductProvider>().deleteAt(index);
    }
  }

  void _scrollToTop() async {
    setState(() => _fabPressedIconToggle = !_fabPressedIconToggle);
    await _sc.animateTo(0,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic);
    await Future.delayed(const Duration(milliseconds: 450));
    if (mounted) setState(() => _fabPressedIconToggle = !_fabPressedIconToggle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('르탄동'),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: _onBell, icon: const Icon(Icons.notifications_none))
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, vm, _) {
          if (vm.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.items.isEmpty) {
            return const Center(child: Text('등록된 상품이 없습니다.'));
          }
          return ListView.separated(
            controller: _sc,
            physics: const BouncingScrollPhysics(),
            itemCount: vm.items.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey.shade300),
            itemBuilder: (context, index) {
              final p = vm.items[index];
              return ProductTile(
                product: p,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProductDetailPage(productId: p.id)),
                ),
                onLongPress: () => _confirmDelete(context, index, p.title),
              );
            },
          );
        },
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: _showFab
            ? FloatingActionButton(
                key: const ValueKey('fab'),
                onPressed: _scrollToTop,
                child: Icon(
                    _fabPressedIconToggle ? Icons.check : Icons.arrow_upward),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
