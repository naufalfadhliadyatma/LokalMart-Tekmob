import 'package:flutter/material.dart';
import '../home/beranda_screen.dart'; // Import sesuai folder kamu

class LokalMartLogin extends StatefulWidget {
  const LokalMartLogin({super.key});

  @override
  State<LokalMartLogin> createState() => _LokalMartLoginState();
}

class _LokalMartLoginState extends State<LokalMartLogin> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BerandaScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE6E3CB), Color(0xE55B5835)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 31),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 54),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: Image.asset(
                      'assets/images/logo_lokalmart.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF424021), Color(0xFF9E9A47)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    blendMode: BlendMode.srcIn,
                    child: const Text(
                      'LokalMart',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  _buildLabel('Name'),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _nameController,
                    hint: 'Masukkan nama Anda',
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Password'),
                  const SizedBox(height: 6),
                  _buildInputField(
                    controller: _passwordController,
                    hint: 'Masukkan password',
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFFD9D9D9),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 131,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: _submitLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB3AF8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFF424021),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF524F2C)),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(
            color: Color.fromARGB(255, 211, 211, 211),
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 211, 211, 211),
              fontSize: 14,
            ),
            suffixIcon: suffixIcon,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
      ),
    );
  }
}
