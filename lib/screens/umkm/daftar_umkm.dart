import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DaftarUMKMScreen extends StatefulWidget {
  const DaftarUMKMScreen({super.key});

  @override
  State<DaftarUMKMScreen> createState() => _DaftarUMKMScreenState();
}

class _DaftarUMKMScreenState extends State<DaftarUMKMScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> produkUMKM = [];
  List<Map<String, dynamic>> _filteredProduk = [];
  Set<String> favoriteProdukIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduk();
    fetchFavorit();
    _searchController.addListener(() {
      final keyword = _searchController.text.toLowerCase();
      setState(() {
        _filteredProduk = produkUMKM
            .where((produk) =>
                (produk['nama'] ?? '').toLowerCase().contains(keyword) ||
                (produk['deskripsi'] ?? '').toLowerCase().contains(keyword))
            .toList();
      });
    });
  }

  Future<void> fetchProduk() async {
    try {
      final data = await Supabase.instance.client
          .from('registrasi_umkm')
          .select()
          .order('id', ascending: false);

      setState(() {
        produkUMKM = List<Map<String, dynamic>>.from(data);
        _filteredProduk = List.from(produkUMKM);
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetchProduk: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> fetchFavorit() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final data = await Supabase.instance.client
        .from('favorit')
        .select('produk_id')
        .eq('user_id', user.id);
    setState(() {
      favoriteProdukIds = {for (var item in data) item['produk_id'] as String};
    });
  }

  Future<void> toggleFavorite(String produkId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    if (favoriteProdukIds.contains(produkId)) {
      await Supabase.instance.client
          .from('favorit')
          .delete()
          .eq('user_id', user.id)
          .eq('produk_id', produkId);
      setState(() {
        favoriteProdukIds.remove(produkId);
      });
    } else {
      await Supabase.instance.client.from('favorit').insert({
        'user_id': user.id,
        'produk_id': produkId,
      });
      setState(() {
        favoriteProdukIds.add(produkId);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F3),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF5B5835),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF5B5835),
                      Color(0xFF6B6440),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/logo-sriharjo.png"),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'UMKM Kalurahan Sriharjo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Temukan Produk UMKM Kesukaanmu!',
                                    style: TextStyle(
                                      color: Color(0xFFCDC99A),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.refresh_rounded,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() => _isLoading = true);
                                  fetchProduk();
                                  fetchFavorit();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Mau cari UMKM apa hari ini?',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: 'Poppins',
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Products Grid
          _isLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF5B5835)),
                      ),
                    ),
                  ),
                )
              : _filteredProduk.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Produk tidak ditemukan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final produk = _filteredProduk[index];
                            return _ItemCard(
                              data: produk,
                              isFavorit:
                                  favoriteProdukIds.contains(produk['id']),
                              onToggleFavorit: () =>
                                  toggleFavorite(produk['id']),
                            );
                          },
                          childCount: _filteredProduk.length,
                        ),
                      ),
                    ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF5B5835),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFCDC99A),
          unselectedItemColor: Colors.white.withOpacity(0.6),
          currentIndex: 1,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, '/beranda');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/umkm');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/profile');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_rounded),
              label: 'UMKM',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isFavorit;
  final VoidCallback onToggleFavorit;

  const _ItemCard({
    required this.data,
    required this.isFavorit,
    required this.onToggleFavorit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(
                    data['image_url'] ?? 'https://placehold.co/200x150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  // Action buttons
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((data['lokasi'] ?? '').toString().isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8B86D),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.location_on_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () async {
                                final url = data['lokasi'];
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            color: isFavorit
                                ? const Color(0xFFE8B86D)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorit
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: isFavorit
                                  ? Colors.white
                                  : const Color(0xFF5B5835),
                              size: 18,
                            ),
                            onPressed: onToggleFavorit,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    data['nama'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFF2C2C2C),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Price
                  Text(
                    'Rp ${data['harga'] ?? 'N/A'}',
                    style: const TextStyle(
                      color: Color(0xFF5B5835),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Expanded(
                    child: Text(
                      data['deskripsi'] ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
