import 'package:flutter/material.dart';
import '../home/beranda_screen.dart'; // ganti sesuai path

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

  // Placeholder untuk upload file
  String _fileName = 'Choose File';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implementasi Firebase simpan data di sini
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BerandaScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E3CB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Register UMKM',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFE6E3CB),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E3CB),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Tambahkan Produk UMKM',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildLabel('Nama UMKM'),
                  _buildTextField(_namaController, 'Nama produk UMKM'),
                  const SizedBox(height: 20),
                  _buildLabel('Harga UMKM'),
                  _buildTextField(_hargaController, 'Harga produk'),
                  const SizedBox(height: 20),
                  _buildLabel('Deskripsi UMKM'),
                  _buildTextField(_deskripsiController, 'Deskripsi produk',
                      maxLines: 5),
                  const SizedBox(height: 20),
                  _buildLabel('Foto Produk'),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Tambah image picker logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD9D9D9),
                          ),
                          child: const Text(
                            'Choose File',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _fileName,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B5835),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Tambah Produk',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
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
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }
}
