import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/edit_profil.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:gstok/presentation/screens/setting_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final user = authProvider.user;

    // ✅ Gunakan fungsi dari AuthProvider langsung
    final fullProfilePhotoUrl = authProvider.getFullProfilePhotoUrl();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: authProvider.isAuthenticated
          ? SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveLayout.getFormWidth(context),
                ),
                child: Column(
                  children: [
                    // Profile Header dengan Avatar dan Gradient
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
                        children: [
                          // ✅ Foto profil dari backend Laravel - DIPERBAIKI
                          Container(
                            width: ResponsiveLayout.isMobile(context)
                                ? 100
                                : 120,
                            height: ResponsiveLayout.isMobile(context)
                                ? 100
                                : 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.onPrimary,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.shadow.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _buildProfileImage(
                              fullProfilePhotoUrl,
                              theme,
                              context,
                            ),
                          ),

                          SizedBox(
                            height: ResponsiveLayout.isMobile(context)
                                ? 16
                                : 20,
                          ),

                          // ✅ Nama pengguna dengan overflow handling
                          Container(
                            width: double.infinity,
                            child: Text(
                              user?.name ?? 'Nama Pengguna',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: ResponsiveLayout.isMobile(context)
                                    ? 18
                                    : 24,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveLayout.isMobile(context) ? 6 : 8,
                          ),

                          // ✅ Email dengan overflow handling
                          Container(
                            width: double.infinity,
                            child: Text(
                              user?.email ?? 'email@example.com',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary.withOpacity(
                                  0.9,
                                ),
                                fontSize: ResponsiveLayout.isMobile(context)
                                    ? 12
                                    : 14,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildMenuButton(
                          'Edit Profil',
                          Icons.edit_rounded,
                          const Color.fromARGB(255, 255, 255, 255),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          ),
                          theme,
                        ),
                        SizedBox(
                          height: ResponsiveLayout.isMobile(context) ? 16 : 20,
                        ),
                        _buildMenuButton(
                          'Pengaturan',
                          Icons.settings_rounded,
                          const Color.fromARGB(255, 255, 255, 255),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ),
                          ),
                          theme,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showLogoutDialog(context, authProvider);
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: Text(
                          'Keluar dari Akun',
                          style: TextStyle(
                            fontSize: ResponsiveLayout.isMobile(context)
                                ? 14
                                : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveLayout.isMobile(context)
                                ? 14
                                : 18,
                            horizontal: ResponsiveLayout.isMobile(context)
                                ? 16
                                : 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: theme.colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveLayout.isMobile(context) ? 16 : 20,
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Silakan login terlebih dahulu',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }

  // ✅ Widget untuk menampilkan gambar profil dengan error handling yang lebih baik
  Widget _buildProfileImage(
    String? imageUrl,
    ThemeData theme,
    BuildContext context,
  ) {
    if (imageUrl == null) {
      return _buildDefaultAvatar(theme, context);
    }

    // Validasi URL sebelum digunakan
    final validUrl = _validateAndFixUrl(imageUrl);
    if (validUrl == null) {
      return _buildDefaultAvatar(theme, context);
    }

    return Image.network(
      validUrl,
      fit: BoxFit.cover,
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
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
        print('❌ Error loading profile photo: $error');
        print('❌ URL yang gagal: $validUrl');
        return _buildDefaultAvatar(theme, context);
      },
    );
  }

  // ✅ Validasi dan perbaiki URL
  String? _validateAndFixUrl(String url) {
    try {
      // Perbaiki URL yang memiliki http:/ (satu slash)
      if (url.startsWith('http:/') && !url.startsWith('http://')) {
        url = url.replaceFirst('http:/', 'http://');
      }
      if (url.startsWith('https:/') && !url.startsWith('https://')) {
        url = url.replaceFirst('https:/', 'https://');
      }

      // Hapus double slash yang tidak perlu, kecuali setelah http://
      url = url.replaceAll(RegExp(r'(?<!http:)/(?=/)'), '');

      return url;
    } catch (e) {
      print('❌ Error validating URL: $e');
      return null;
    }
  }

  // ✅ Widget untuk avatar default
  Widget _buildDefaultAvatar(ThemeData theme, BuildContext context) {
    return Container(
      color: theme.colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: ResponsiveLayout.isMobile(context) ? 40 : 60,
        color: theme.colorScheme.onPrimary.withOpacity(0.7),
      ),
    );
  }

  Widget _buildMenuButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white70,
          size: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
