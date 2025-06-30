import 'package:flutter/material.dart';

class SejarahSriharjoScreen extends StatelessWidget {
  const SejarahSriharjoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B5835),
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header with gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B5835), Color(0xFF6B6340)],
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/beranda'),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Sejarah Sriharjo',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFCDC99A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Section with logo and title
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF5B5835).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF5B5835).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Image.asset(
                                  'assets/images/logo-sriharjo.png',
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Kalurahan Sriharjo',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF5B5835),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 4,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5B5835),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // History Section
                        _buildSectionCard(
                          title: 'Sejarah Kalurahan Sriharjo',
                          icon: Icons.history,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHistoryCard(
                                year: '1946',
                                title: 'Pembentukan Kalurahan',
                                content:
                                    'Kalurahan Sriharjo dibentuk pada tahun 1946.',
                              ),
                              const SizedBox(height: 16),
                              _buildInfoCard(
                                title: 'Asal Nama "Sriharjo"',
                                content:
                                    'Menurut mitos Jawa, kata "Sriharjo" adalah pemberian dari Dewi Sri dan "harjo" yaitu raharjo atau sejahtera. Jadi, nama Sriharjo berarti desa yang sejahtera dengan mata pencaharian pokok warganya adalah bercocok tanam.',
                                icon: Icons.grass,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Original Villages Section
                        _buildSectionCard(
                          title: 'Kalurahan Asal',
                          icon: Icons.merge_type,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kalurahan Sriharjo merupakan penggabungan dari tiga kalurahan lama:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF5B5835),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildVillageGrid([
                                'Kalurahan Mojohuro',
                                'Kalurahan Dogongan',
                                'Kalurahan Kedungmiri',
                              ]),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Office History Section
                        _buildSectionCard(
                          title: 'Sejarah Kantor',
                          icon: Icons.business,
                          child: Column(
                            children: [
                              _buildTimelineItem(
                                year: '1946',
                                title: 'Kantor Sementara',
                                description:
                                    'Kantor sementara bertempat di rumah Bapak Sosro Margono di Padukuhan Mojohuro.',
                                isFirst: true,
                              ),
                              _buildTimelineItem(
                                year: '1951',
                                title: 'Kantor Baru',
                                description:
                                    'Dibangun kantor baru Pemerintah Kalurahan Sriharjo di atas tanah kas desa di wilayah Padukuhan Mojohuro.',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Padukuhan Section
                        _buildSectionCard(
                          title: 'Pembagian Padukuhan',
                          icon: Icons.location_on,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Wilayah padukuhan Kalurahan Sriharjo:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF5B5835),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildPadukahanGrid([
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

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5B5835).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B5835),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0xFF5B5835),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String year,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5B5835).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF5B5835).withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF5B5835),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              year,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFF5B5835),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    color: Color(0xFF5B5835),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFCDC99A).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF5B5835),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF5B5835),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: Color(0xFF5B5835),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVillageGrid(List<String> villages) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: villages.map((village) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF5B5835),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            village,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFF5B5835),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: const Color(0xFF5B5835).withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCDC99A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    year,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Color(0xFF5B5835),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Color(0xFF5B5835),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    color: Color(0xFF5B5835),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPadukahanGrid(List<String> padukuhans) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemCount: padukuhans.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF5B5835).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFF5B5835).withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF5B5835),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  padukuhans[index].replaceAll('Padukuhan ', ''),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Color(0xFF5B5835),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
