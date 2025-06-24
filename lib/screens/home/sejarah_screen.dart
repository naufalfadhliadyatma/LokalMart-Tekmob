import 'package:flutter/material.dart';

class SejarahSriharjoScreen extends StatelessWidget {
  const SejarahSriharjoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar Manual (Back + Title)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sejarah Sriharjo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Isi Konten
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E3CB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo dan Judul
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo-sriharjo.png',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Kalurahan Sriharjo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Sejarah Kalurahan Sriharjo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Kalurahan Sriharjo dibentuk pada tahun 1946. Sedangkan nama ‘Sriharjo’ diambil dari geografi wilayah dan mata pencaharian penduduk. '
                        'Menurut mitos Jawa, kata ‘Sriharjo’ adalah pemberian dari Dewi Sri dan ‘harjo’ yaitu raharjo atau sejahtera. Jadi, nama Sriharjo berarti desa yang sejahtera dengan mata pencaharian pokok warganya adalah bercocok tanam.',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kalurahan Sriharjo awalnya merupakan penggabungan tiga kalurahan lama, yaitu:',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 8),
                      _buildNumberedList([
                        'Kalurahan Mojohuro',
                        'Kalurahan Dogongan',
                        'Kalurahan Kedungmiri',
                      ]),
                      const SizedBox(height: 12),
                      const Text(
                        'Kantor sementara pada waktu penggabungan bertempat di rumah Bapak Sosro Margono di Padukuhan Mojohuro. '
                        'Pada tahun 1951 dibangun kantor baru Pemerintah Kalurahan Sriharjo di atas tanah kas desa di wilayah Padukuhan Mojohuro.',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Berikut pembagian wilayah padukuhan Kalurahan Sriharjo pada saat itu:',
                        style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 8),
                      _buildNumberedList([
                        'Padukuhan Miri',
                        'Padukuhan Jati',
                        'Padukuhan Mojohuro',
                        'Padukuhan Pelemadu',
                        'Padukuhan Sungapan',
                        'Padukuhan Gondosuli',
                        'Padukuhan Trukan',
                        'Padukuhan Dogongan',
                        'Padukuhan Ketos',
                        'Padukuhan Ngrancah',
                        'Padukuhan Pengkol',
                        'Padukuhan Sompok',
                        'Padukuhan Wunut',
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat list bernomor
  Widget _buildNumberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '${index + 1}. ${items[index]}',
            style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
          ),
        );
      }),
    );
  }
}
