import 'package:flutter/material.dart';
import '../home/beranda_screen.dart'; // Ganti dengan path kamu jika berbeda

class RegisterUmkmScreen extends StatefulWidget {
  const RegisterUmkmScreen({super.key});

  @override
  State<RegisterUmkmScreen> createState() => _RegisterUmkmScreenState();
}

class _RegisterUmkmScreenState extends State<RegisterUmkmScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // TODO: Tambahkan fungsi picker dan Firebase upload jika sudah setup

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Simpan data ke Firebase nanti
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
      Navigator.pop(context); // Kembali ke beranda
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header: Back + Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                height: 28,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/beranda'),
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Register UMKM',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Body Container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6E3CB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Tambahkan Produk UMKM',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildLabel('Nama UMKM'),
                        _buildInput(_namaController),
                        const SizedBox(height: 20),
                        _buildLabel('Harga UMKM'),
                        _buildInput(_hargaController,
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 20),
                        _buildLabel('Deskripsi UMKM'),
                        _buildInput(_deskripsiController, maxLines: 4),
                        const SizedBox(height: 20),
                        _buildLabel('Foto Produk'),
                        Container(
                          height: 60,
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF5B5835)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Tambahkan fungsi pilih gambar
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD2D2D2),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .zero, // sudut kotak (tidak melengkung)
                              ),
                              fixedSize: const Size(50,
                                  45), // atur ukuran: lebar = 150, tinggi = 45
                            ),
                            child: const Text(
                              'Choose File',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B5835),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Tambah Produk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: double.infinity,
      height: maxLines == 1 ? 60 : 137,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF5B5835)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
