import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final phone = _phoneController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password tidak sama'),
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'phone': phone},
      );

      if (response.user != null) {
        Navigator.pushReplacementNamed(context, '/beranda');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal daftar: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String hint, String iconPath,
      {Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color(0xFF5B5835).withOpacity(0.6),
        fontSize: 16,
      ),
      prefixIcon: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFCDC99A).withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(iconPath, width: 20, height: 20),
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: const Color(0xFFCDC99A).withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: const Color(0xFFCDC99A).withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF5B5835), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFCDC99A),
              const Color(0xFFCDC99A).withOpacity(0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan tombol kembali yang lebih elegant
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Color(0xFF5B5835), size: 20),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ),
                    const Spacer(),
                    // Logo atau dekorasi kecil
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B5835),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.person_add,
                          color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),

              // Form dengan animasi
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 40, 30, 24),
                      child: ListView(
                        children: [
                          // Header text dengan style yang lebih menarik
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bergabung',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5B5835),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Buat akun baru untuk memulai',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      const Color(0xFF5B5835).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Form fields dengan spacing yang lebih baik
                          _buildInputField(
                            controller: _emailController,
                            hint: 'Email',
                            iconPath: 'assets/images/mail.png',
                          ),
                          const SizedBox(height: 24),

                          _buildInputField(
                            controller: _passwordController,
                            hint: 'Kata sandi',
                            iconPath: 'assets/images/icon-lock.png',
                            obscureText: _obscurePassword,
                            suffixIcon:
                                _buildPasswordToggle(_obscurePassword, () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            }),
                          ),
                          const SizedBox(height: 24),

                          _buildInputField(
                            controller: _confirmPasswordController,
                            hint: 'Konfirmasi kata sandi',
                            iconPath: 'assets/images/icon-lock.png',
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: _buildPasswordToggle(
                                _obscureConfirmPassword, () {
                              setState(() => _obscureConfirmPassword =
                                  !_obscureConfirmPassword);
                            }),
                          ),
                          const SizedBox(height: 24),

                          _buildInputField(
                            controller: _phoneController,
                            hint: 'Nomor telepon',
                            iconPath: 'assets/images/call.png',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 40),

                          // Tombol dengan efek hover yang lebih smooth
                          MouseRegion(
                            onEnter: (_) => setState(() => _isHovering = true),
                            onExit: (_) => setState(() => _isHovering = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.identity()
                                ..scale(_isHovering ? 1.02 : 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: _isHovering
                                        ? [
                                            const Color(0xFF817D51),
                                            const Color(0xFF5B5835)
                                          ]
                                        : [
                                            const Color(0xFF5B5835),
                                            const Color(0xFF5B5835)
                                          ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF5B5835)
                                          .withOpacity(0.3),
                                      blurRadius: _isHovering ? 15 : 10,
                                      offset: Offset(0, _isHovering ? 8 : 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _signUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    minimumSize:
                                        const Size(double.infinity, 56),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Footer text
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  color:
                                      const Color(0xFF5B5835).withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Masuk',
                                    style: TextStyle(
                                      color: const Color(0xFF5B5835),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: _inputDecoration(hint, iconPath, suffixIcon: suffixIcon),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF5B5835),
        ),
      ),
    );
  }

  Widget _buildPasswordToggle(bool obscureText, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(12),
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFCDC99A).withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF5B5835),
            size: 18,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
