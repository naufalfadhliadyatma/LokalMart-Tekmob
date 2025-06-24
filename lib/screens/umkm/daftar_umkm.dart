import 'package:flutter/material.dart';

class DaftarUMKMScreen extends StatefulWidget {
  const DaftarUMKMScreen({super.key});

  @override
  State<DaftarUMKMScreen> createState() => _DaftarUMKMScreenState();
}

class _DaftarUMKMScreenState extends State<DaftarUMKMScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> produkUMKM = [
    {
      'nama': 'Keripik Tempe',
      'harga': 'Rp 15.000',
      'deskripsi': 'Keripik enak yang dibuat dari tempe berkualitas',
      'gambar': 'assets/images/keripik.png'
    },
    {
      'nama': 'Mie Ayam',
      'harga': 'Rp 10.000',
      'deskripsi': 'Mie Ayam Bu Tuti dengan tekstur mie yang berkualitas',
      'gambar': 'assets/images/mie-ayam.png'
    },
    {
      'nama': 'Kerajinan Kayu',
      'harga': 'Rp 300.000',
      'deskripsi': 'Keripik enak yang dibuat dari kayu berkualitas',
      'gambar': 'assets/images/kerajinan-kayu.png'
    },
    {
      'nama': 'Rempeyek',
      'harga': 'Rp 9.000',
      'deskripsi': 'Rempeyek Bu Indah dengan kacang berkualitas',
      'gambar': 'assets/images/rempeyek.png'
    },
    {
      'nama': 'Angkringan',
      'harga': 'Rp 5.000',
      'deskripsi': 'Angkringan pak keman yang murah dan lengkap',
      'gambar': 'assets/images/angkringan.png'
    },
    {
      'nama': 'Wedang Uwuh',
      'harga': 'Rp 10.000',
      'deskripsi': 'Wedang uwuh pak gun dengan rempah berkualitas',
      'gambar': 'assets/images/Wedang-uwuh.png'
    },
  ];

  List<Map<String, String>> _filteredProduk = [];

  @override
  void initState() {
    super.initState();
    _filteredProduk = List.from(produkUMKM);

    _searchController.addListener(() {
      final keyword = _searchController.text.toLowerCase();
      setState(() {
        _filteredProduk = produkUMKM
            .where((produk) =>
                produk['nama']!.toLowerCase().contains(keyword) ||
                produk['deskripsi']!.toLowerCase().contains(keyword))
            .toList();
      });
    });
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
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'UMKM Kalurahan Sriharjo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            const Text(
              'Temukan Produk UMKM Kesukaanmu!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            Container(
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
            const SizedBox(height: 16),
            Expanded(
              child: _filteredProduk.isEmpty
                  ? const Center(
                      child: Text(
                        'Produk tidak ditemukan',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                      children: _filteredProduk.map((produk) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.asset(
                                  produk['gambar']!,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      produk['nama']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      produk['harga']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      produk['deskripsi']!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        color: Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(Icons.location_on, size: 16),
                                        Icon(Icons.bookmark_border, size: 16),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
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
            Navigator.pushNamed(context, '/umkm');
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
