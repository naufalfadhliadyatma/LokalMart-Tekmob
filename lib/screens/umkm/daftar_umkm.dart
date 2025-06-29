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
      backgroundColor: const Color(0xFFE6E3CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E3CB),
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo-sriharjo.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 247,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'UMKM Kalurahan Sriharjo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Temukan Produk UMKM Kesukaanmu!',
                    style: TextStyle(
                      color: Color(0xFF969292),
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() => _isLoading = true);
              fetchProduk();
              fetchFavorit();
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Colors.black45),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 12),
                      decoration: const InputDecoration(
                        hintText: 'Mau cari umkm apa?',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProduk.isEmpty
                    ? const Center(child: Text('Produk tidak ditemukan'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 12,
                            runSpacing: 14,
                            children: _filteredProduk.map((produk) {
                              return _ItemCard(
                                data: produk,
                                isFavorit:
                                    favoriteProdukIds.contains(produk['id']),
                                onToggleFavorit: () =>
                                    toggleFavorite(produk['id']),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF5B5835),
        selectedItemColor: const Color(0xFFE6E3CB),
        unselectedItemColor: const Color(0xFFE6E3CB),
        currentIndex: 1,
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'UMKM'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
      width: 175,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(-2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 175,
              height: 113,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      data['image_url'] ?? 'https://placehold.co/175x113'),
                  fit: BoxFit.cover,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 11,
            top: 118,
            child: Text(
              data['nama'] ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            left: 11,
            top: 138,
            child: Text(
              'Rp ${data['harga'] ?? 'N/A'}',
              style: const TextStyle(
                color: Color(0xFF55554D),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 11,
            top: 159,
            child: SizedBox(
              width: 140,
              child: Text(
                data['deskripsi'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFB1B1B1),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Positioned(
            left: 119,
            top: 118,
            child: Row(
              children: [
                if ((data['lokasi'] ?? '').toString().isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      final url = data['lokasi'];
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: const Icon(Icons.location_on,
                        size: 20, color: Color(0xFF5B5835)),
                  ),
                IconButton(
                  icon: Icon(
                    isFavorit ? Icons.bookmark : Icons.bookmark_border,
                    color: const Color(0xFF5B5835),
                    size: 20,
                  ),
                  onPressed: onToggleFavorit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
