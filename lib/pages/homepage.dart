import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/product.dart';
import 'category_page.dart';
import '../widgets/common_widgets.dart';
import 'profile.dart'; // ✅ Make sure this path is correct

class HomePage extends StatefulWidget {
  final Map<String, int> cart;
  final Set<String> fav;
  final Function(dynamic) onAdd;
  final Function(dynamic) onFav;
  final Function(dynamic) onOpenDetail;

  const HomePage({
    super.key,
    required this.cart,
    required this.fav,
    required this.onAdd,
    required this.onFav,
    required this.onOpenDetail,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => searchQuery = query);
    });
  }

  List<Product> get filteredProducts {
    List<Product> products = kProducts;

    if (selectedCategory != null) {
      products = products.where((p) => p.tag == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      products = products.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.tag.toLowerCase().contains(q)).toList();
    }

    return products;
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final promos = kPromoImages;

    return Scaffold(
      appBar: null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          // ✅ Search + Avatar (RIGHT side)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SearchBox(
                  hint: 'Search for products',
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(
                        onOpenOrders: () {
                          // ✅ Hook this later to real Orders page if needed
                          debugPrint("Open Orders tapped from Profile");
                        },
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150?img=5',
                  ),
                  backgroundColor: cs.primaryContainer,
                  onBackgroundImageError: (_, __) {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ Greeting with user name from Firestore
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              debugPrint('📱 Homepage greeting: state=${snapshot.connectionState}, error=${snapshot.hasError}');
              
              String userName = 'User';
              
              // Handle errors gracefully
              if (snapshot.hasError) {
                debugPrint('❌ Firestore error in greeting: ${snapshot.error}');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Hi! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
              }
              
              // While loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Hi! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                );
              }
              
              // Get user name from Firestore
              if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                try {
                  userName = snapshot.data!['fullName'] ?? 'User';
                  debugPrint('✅ Got user name: $userName');
                } catch (e) {
                  debugPrint('⚠️ Error getting fullName: $e');
                  userName = 'User';
                }
              }
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Hi, $userName 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            },
          ),

          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 16 / 7,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.92),
              itemCount: promos.length,
              itemBuilder: (ctx, i) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  promos[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ImgBroken(),
                  loadingBuilder: (c, child, progress) =>
                      progress == null ? child : const ImgPlaceholder(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ✅ Categories
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final category = kCategories[i];
                final name = category.$1;
                final icon = category.$2;
                final color = category.$3;
                final items = category.$4;
                final isSelected = selectedCategory == name;

                return GestureDetector(
                  onTap: () {
                    _selectCategory(name);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CategoryPage(
                          category: name,
                          cart: widget.cart,
                          fav: widget.fav,
                          onAdd: widget.onAdd,
                          onFav: widget.onFav,
                          onOpenDetail: widget.onOpenDetail,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isSelected ? color.withOpacity(.3) : color.withOpacity(.22),
                          isSelected ? color.withOpacity(.15) : color.withOpacity(.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: color.withOpacity(.5), width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: color),
                        const Spacer(),
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w800,
                          ),
                        ),
                        Text(
                          items,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? cs.primary : cs.onSurface.withOpacity(.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Products grid header
          Row(
            children: [
              Text(
                selectedCategory ?? 'Favourite Products',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Text(
                '(${filteredProducts.length} items)',
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withOpacity(.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ✅ Products grid
          ProductGrid(
            products: filteredProducts,
            fav: widget.fav,
            onAdd: widget.onAdd,
            onFav: widget.onFav,
            onOpenDetail: widget.onOpenDetail,
          ),

          const SizedBox(height: 18),

          const SizedBox(height: 6),
          Text(
            'Other Login w3Grocery package',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          // ✅ Vendor & Driver login cards
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Use named route so the app-level login handler is used
                    Navigator.of(context).pushNamed('/login', arguments: 'vendor');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.teal[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.store,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'W3 Vendor',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.tonal(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login', arguments: 'vendor');
                          },
                          child: const Text('Click Now'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/login', arguments: 'driver');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.delivery_dining,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'W3 Driver',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.tonal(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/login', arguments: 'driver');
                          },
                          child: const Text('Click Now'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Set<String> fav;
  final Function(dynamic) onAdd;
  final Function(dynamic) onFav;
  final Function(dynamic) onOpenDetail;

  const ProductGrid({
    super.key,
    required this.products,
    required this.fav,
    required this.onAdd,
    required this.onFav,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: .72,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return ProductCard(
          p: p,
          inFav: fav.contains(p.id),
          onFav: () => onFav(p),
          onAdd: () => onAdd(p),
          onOpen: () => onOpenDetail(p),
        );
      },
    );
  }
}
