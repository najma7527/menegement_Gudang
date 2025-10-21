import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../presentation/screens/responsive_layout.dart';
import '../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  File? _selectedImage; // untuk mobile
  Uint8List? _webImageBytes; // untuk web
  String? _webImageName;

  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(
      text: authProvider.user?.name ?? '',
    );
    _emailController = TextEditingController(
      text: authProvider.user?.email ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 🔹 Pilih foto profil
  Future<void> _pickImage() async {
    try {
      if (kIsWeb) {
        // Web pakai FilePicker
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );
        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          if (file.size > 5 * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ukuran file maksimal 5MB'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          setState(() {
            _webImageBytes = file.bytes;
            _webImageName = file.name;
          });
        }
      } else {
        // Mobile pakai ImagePicker
        final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxWidth: 800,
        );
        if (pickedFile != null) {
          final file = File(pickedFile.path);
          final fileSize = await file.length();
          if (fileSize > 5 * 1024 * 1024) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Ukuran file maksimal 5MB'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          setState(() {
            _selectedImage = file;
          });
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔹 Update profil
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Format email tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token == null || authProvider.token!.isEmpty) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sesi telah berakhir, silakan login kembali'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    print("🔄 Memulai update profil...");

    bool success = await authProvider.updateProfileWithPhoto(
      name: _nameController.text.trim(),
      email: email,
      imageFile: kIsWeb
          ? (_webImageBytes != null
                ? {'bytes': _webImageBytes, 'name': _webImageName}
                : null)
          : _selectedImage,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Profil berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      if (!authProvider.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🔐 Sesi expired, silakan login kembali'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal memperbarui profil. Periksa data Anda.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Widget _buildProfileAvatar(AuthProvider authProvider, ThemeData theme) {
    final imageUrl = authProvider.user?.profilePhoto;

    final hasNewImage =
        (kIsWeb && _webImageBytes != null) ||
        (!kIsWeb && _selectedImage != null);

    // Cek apakah ada gambar dari server
    final hasServerImage = imageUrl != null && imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // ✅ Container lingkaran avatar - DISESUAIKAN dengan profil screen
          Container(
            width: ResponsiveLayout.isMobile(context) ? 100 : 120,
            height: ResponsiveLayout.isMobile(context) ? 100 : 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    theme.colorScheme.onPrimary, // ✅ Sama dengan profil screen
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildAvatarContent(
                authProvider,
                theme,
                hasNewImage,
                hasServerImage,
                imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Widget untuk konten avatar (gambar atau icon)
  Widget _buildAvatarContent(
    AuthProvider authProvider,
    ThemeData theme,
    bool hasNewImage,
    bool hasServerImage,
    String? imageUrl,
  ) {
    // Prioritas 1: Gambar yang baru dipilih
    if (kIsWeb && _webImageBytes != null) {
      return Image.memory(
        _webImageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatarIcon(theme);
        },
      );
    } else if (!kIsWeb && _selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatarIcon(theme);
        },
      );
    }
    // Prioritas 2: Gambar dari server
    else if (hasServerImage) {
      final fullImageUrl = imageUrl!.startsWith('http')
          ? imageUrl
          : '${authProvider.baseUrl.replaceAll('/api', '')}/$imageUrl'
                .replaceAll('//', '/');

      return Image.network(
        fullImageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error loading profile image: $error');
          return _buildDefaultAvatarIcon(theme);
        },
      );
    } else {
      return _buildDefaultAvatarIcon(theme);
    }
  }

  // ✅ Widget untuk icon avatar default - DISESUAIKAN dengan profil screen
  Widget _buildDefaultAvatarIcon(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: ResponsiveLayout.isMobile(context) ? 40 : 60,
        color: theme.colorScheme.onPrimary.withOpacity(
          0.7,
        ), // ✅ Sama dengan profil screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () async {
            final theme = Theme.of(context);

            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: theme.colorScheme.error,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Konfirmasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                content: const Text(
                  "Apakah Anda yakin ingin keluar?\nPerubahan yang belum disimpan akan hilang.",
                  style: TextStyle(fontSize: 15, height: 1.4),
                ),
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          child: const Text("Batal"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context, true),
                          icon: const Icon(Icons.exit_to_app_rounded, size: 20),
                          label: const Text("Ya, Keluar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            shadowColor: theme.colorScheme.error.withOpacity(
                              0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );

            if (shouldExit == true) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getFormWidth(context),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ✅ Container dengan gradient background seperti profil screen
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    ResponsiveLayout.isMobile(context) ? 20 : 30,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.9),
                        theme.colorScheme.primaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [_buildProfileAvatar(authProvider, theme)],
                  ),
                ),

                const SizedBox(height: 24),

                _buildFormField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    if (value.length < 2) {
                      return 'Nama terlalu pendek';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildFormField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!_isValidEmail(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveLayout.isMobile(context) ? 14 : 18,
                        horizontal: ResponsiveLayout.isMobile(context)
                            ? 16
                            : 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            'Simpan Perubahan',
                            style: TextStyle(
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? 14
                                  : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
