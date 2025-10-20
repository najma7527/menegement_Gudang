import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gstok/core/constants/app_colors.dart';
import 'package:gstok/presentation/screens/bantuan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _saveSettings(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Yuk coba aplikasi keren ini!',
      subject: 'Bagikan Aplikasi',
    );
  }

  Future<void> _contactUs() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=Feedback Aplikasi&body=Halo tim support,',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak bisa membuka aplikasi email',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _goToHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.surface,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.surface,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildModernActionItem(
                    Icons.share_rounded,
                    'Bagikan Aplikasi',
                    'Bagikan aplikasi ke teman Anda',
                    _shareApp,
                  ),
                  _buildDivider(),
                  _buildModernActionItem(
                    Icons.email_rounded,
                    'Hubungi Kami',
                    'Kirim masukan dan saran',
                    _contactUs,
                  ),
                  _buildDivider(),
                  _buildModernActionItem(
                    Icons.help_center_rounded,
                    'Bantuan',
                    'Pusat bantuan dan panduan',
                    _goToHelp,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Additional Settings Section
            // Text(
            //   'Lainnya',
            //   style: GoogleFonts.poppins(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.grey700,
            //     letterSpacing: -0.5,
            //   ),
            // ),
            // const SizedBox(height: 16),
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppColors.surface,
            //     borderRadius: BorderRadius.circular(16),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.08),
            //         blurRadius: 12,
            //         offset: const Offset(0, 4),
            //       ),
            //     ],
            //   ),
            // child: Column(
            //   children: [
            //     _buildModernActionItem(
            //       Icons.info_rounded,
            //       'Tentang Aplikasi',
            //       'Versi dan informasi aplikasi',
            //       () {},
            //     ),
            //     _buildDivider(),
            //     _buildModernActionItem(
            //       Icons.security_rounded,
            //       'Kebijakan Privasi',
            //       'Baca kebijakan privasi kami',
            //       () {},
            //     ),
            //   ],
            // ),
            // ),

            // const SizedBox(height: 32),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Versi 1.0.0',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2024 GSTOK App',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: AppColors.grey100, thickness: 1),
    );
  }

  Widget _buildModernActionItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isWarning = false,
  }) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isWarning
              ? AppColors.error.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isWarning
                ? AppColors.error.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isWarning ? AppColors.error : AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isWarning ? AppColors.error : AppColors.grey800,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(color: AppColors.grey500, fontSize: 13),
      ),
      trailing: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.grey400,
          size: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
