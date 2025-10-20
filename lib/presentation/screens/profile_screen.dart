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
                          // Avatar Circle
                          Container(
                            width: ResponsiveLayout.isMobile(context)
                                ? 80
                                : 100,
                            height: ResponsiveLayout.isMobile(context)
                                ? 80
                                : 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.onPrimary,
                                width: 3,
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  theme.colorScheme.onPrimary.withOpacity(0.8),
                                  theme.colorScheme.onPrimary.withOpacity(0.4),
                                ],
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
                            child: Icon(
                              Icons.person,
                              size: ResponsiveLayout.isMobile(context)
                                  ? 35
                                  : 50,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveLayout.isMobile(context)
                                ? 16
                                : 20,
                          ),
                          Text(
                            '@${authProvider.user?.username ?? 'username'}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? 18
                                  : 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: ResponsiveLayout.isMobile(context) ? 6 : 8,
                          ),
                          Text(
                            authProvider.user?.name ?? 'Nama Pengguna',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? 18
                                  : 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: ResponsiveLayout.isMobile(context) ? 6 : 8,
                          ),
                          // User Email
                          Text(
                            authProvider.user?.email ?? 'email@example.com',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.9,
                              ),
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? 12
                                  : 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: ResponsiveLayout.isMobile(context) ? 24 : 32,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // Dalam method build ProfileScreen, tambahkan ini di bagian menu buttons:
                        _buildMenuButton(
                          'Edit Profil',
                          Icons.edit_rounded,
                          const Color.fromARGB(255, 74, 144, 226),
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

                    SizedBox(
                      height: ResponsiveLayout.isMobile(context) ? 24 : 32,
                    ),
                    // Logout Button dengan desain lebih menonjol
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
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
                            shadowColor: theme.colorScheme.error.withOpacity(
                              0.3,
                            ),
                          ),
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
          : Center(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: ResponsiveLayout.isMobile(context) ? 80 : 120,
                      height: ResponsiveLayout.isMobile(context) ? 80 : 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outline.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_off_rounded,
                        size: ResponsiveLayout.isMobile(context) ? 40 : 60,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveLayout.isMobile(context) ? 16 : 24,
                    ),
                    Text(
                      'Silakan login terlebih dahulu',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveLayout.isMobile(context) ? 18 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: ResponsiveLayout.isMobile(context) ? 6 : 8,
                    ),
                    Text(
                      'Login untuk mengakses profil dan fitur lengkap lainnya',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                        fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: ResponsiveLayout.isMobile(context) ? 24 : 32,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveLayout.isMobile(context)
                                ? 14
                                : 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Login Sekarang',
                          style: TextStyle(
                            fontSize: ResponsiveLayout.isMobile(context)
                                ? 14
                                : 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveLayout.isMobile(context) ? 12 : 16,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to register page
                      },
                      child: Text(
                        'Belum punya akun? Daftar di sini',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 12
                              : 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMenuButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    dynamic theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
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
        ),
        trailing: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white70,
            size: 14,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 12 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveLayout.isMobile(context) ? 32 : 40,
            height: ResponsiveLayout.isMobile(context) ? 32 : 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: ResponsiveLayout.isMobile(context) ? 16 : 20,
            ),
          ),
          SizedBox(width: ResponsiveLayout.isMobile(context) ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveLayout.isMobile(context) ? 10 : 12,
                  ),
                ),
                SizedBox(height: ResponsiveLayout.isMobile(context) ? 2 : 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.3),
          child: Container(
            width: ResponsiveLayout.isMobile(context)
                ? MediaQuery.of(context).size.width * 0.8
                : 400,
            padding: EdgeInsets.all(
              ResponsiveLayout.isMobile(context) ? 20 : 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: ResponsiveLayout.isMobile(context) ? 60 : 80,
                  height: ResponsiveLayout.isMobile(context) ? 60 : 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: ResponsiveLayout.isMobile(context) ? 30 : 40,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 20),

                // Title
                Text(
                  'Konfirmasi Logout',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveLayout.isMobile(context) ? 18 : 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveLayout.isMobile(context) ? 8 : 12),

                // Content
                Text(
                  'Apakah Anda yakin ingin keluar dari akun ini?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveLayout.isMobile(context) ? 20 : 24),

                // 🔹 Tombol sejajar (Batal & Logout)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveLayout.isMobile(context)
                                ? 10
                                : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12), // 🔹 jarak antar tombol
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          authProvider.logout();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onError,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveLayout.isMobile(context)
                                ? 10
                                : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
