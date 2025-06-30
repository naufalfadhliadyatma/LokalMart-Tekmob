import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterUmkmScreen extends StatefulWidget {
  const RegisterUmkmScreen({super.key});

  @override
  State<RegisterUmkmScreen> createState() => _RegisterUmkmScreenState();
}

class _RegisterUmkmScreenState extends State<RegisterUmkmScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  XFile? _selectedImage;
  String? _uploadedImageUrl;
  bool _isSubmitting = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _selectedImage = pickedFile;
    });

    _showCustomSnackBar('Image selected! It will be uploaded when you submit',
        Icons.check_circle, Colors.green);
  }

  void _showCustomSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        _showCustomSnackBar(
            'Please select an image first', Icons.error, Colors.red);
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        final fileBytes = await _selectedImage!.readAsBytes();
        final fileExt = path.extension(_selectedImage!.path);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
        final filePath = 'produk/$fileName';

        final storage = Supabase.instance.client.storage;
        await storage.from('gambar').uploadBinary(filePath, fileBytes);
        final publicUrl = storage.from('gambar').getPublicUrl(filePath);

        setState(() {
          _uploadedImageUrl = publicUrl;
        });

        await Supabase.instance.client.from('registrasi_umkm').insert({
          'nama': _namaController.text,
          'harga': int.tryParse(_hargaController.text) ?? 0,
          'deskripsi': _deskripsiController.text,
          'image_url': publicUrl,
          'lokasi': _lokasiController.text,
        });

        _showCustomSnackBar(
            'Product successfully added!', Icons.check_circle, Colors.green);
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context, true);
      } catch (e) {
        _showCustomSnackBar(
            'Failed to add product: $e', Icons.error, Colors.red);
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5B5835),
              Color(0xFF7A734A),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Custom App Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Register UMKM',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5B5835)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.store,
                                        size: 40,
                                        color: Color(0xFF5B5835),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Add Your UMKM Product',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Fill in the details to register your product',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Form Fields
                              _buildModernInput(
                                label: 'UMKM Name',
                                controller: _namaController,
                                icon: Icons.business,
                                maxLength: 16,
                              ),
                              const SizedBox(height: 20),

                              _buildModernInput(
                                label: 'Price (IDR)',
                                controller: _hargaController,
                                icon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                prefix: 'Rp ',
                              ),
                              const SizedBox(height: 20),

                              _buildModernInput(
                                label: 'Product Description',
                                controller: _deskripsiController,
                                icon: Icons.description,
                                maxLines: 4,
                                maxLength: 40,
                              ),
                              const SizedBox(height: 20),

                              _buildModernInput(
                                label: 'Google Maps Location Link',
                                controller: _lokasiController,
                                icon: Icons.location_on,
                              ),
                              const SizedBox(height: 20),

                              // Image Selection Section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Product Photo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Image picker container
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      width: double.infinity,
                                      height:
                                          _selectedImage != null ? 200 : 120,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F7F7),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(0xFF5B5835)
                                              .withOpacity(0.3),
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: _selectedImage != null
                                          ? Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  child: kIsWeb
                                                      ? Image.network(
                                                          _selectedImage!.path,
                                                          width:
                                                              double.infinity,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.file(
                                                          File(_selectedImage!
                                                              .path),
                                                          width:
                                                              double.infinity,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF5B5835)
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: const Icon(
                                                    Icons.add_photo_alternate,
                                                    size: 32,
                                                    color: Color(0xFF5B5835),
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                const Text(
                                                  'Tap to select product image',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF5B5835),
                                                  ),
                                                ),
                                                Text(
                                                  'JPG, PNG files supported',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Submit Button
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF5B5835),
                                      Color(0xFF7A734A)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF5B5835)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: _isSubmitting ? null : _submitForm,
                                    child: Center(
                                      child: _isSubmitting
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.add_business,
                                                    color: Colors.white,
                                                    size: 20),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Add Product',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
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
    );
  }

  Widget _buildModernInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF5B5835).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: [
              if (keyboardType == TextInputType.number)
                FilteringTextInputFormatter.digitsOnly,
              if (maxLength != null)
                LengthLimitingTextInputFormatter(maxLength),
            ],
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'This field is required';
              return null;
            },
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Color(0xFF2D3748),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF5B5835).withOpacity(0.7),
                size: 20,
              ),
              prefixText: prefix,
              prefixStyle: const TextStyle(
                color: Color(0xFF5B5835),
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: maxLines > 1 ? 16 : 12,
              ),
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
