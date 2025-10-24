import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import '../../../core/constants/app_colors.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Bantuan & Panduan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: ResponsiveLayout.isMobile(context) ? 20 : 24,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getFormWidth(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(context),
              SizedBox(height: 32),

              // FAQ Section
              _buildSectionTitle(
                'Pertanyaan Umum',
                Icons.help_outline,
                context,
              ),
              SizedBox(height: 16),
              _buildFAQItem(
                context: context,
                question: 'Bagaimana cara menambah barang baru?',
                answer:
                    'Pergi ke menu "Barang" → Tekan tombol "+" → Isi form barang → Simpan',
              ),
              _buildFAQItem(
                context: context,
                question: 'Apa perbedaan transaksi masuk dan keluar?',
                answer:
                    'Transaksi masuk menambah stok barang, transaksi keluar mengurangi stok barang',
              ),
              _buildFAQItem(
                context: context,
                question: 'Bagaimana mengatur kategori barang?',
                answer:
                    'Pergi ke menu "Kategori" → Tambah kategori baru → Gunakan kategori saat menambah barang',
              ),
              _buildFAQItem(
                context: context,
                question: 'Bagaimana mengubah informasi nama dan email?',
                answer:
                    'Pergi ke menu "Edit Profil" → Edit Profil → Simpan perubahan',
              ),

              SizedBox(height: 32),

              _buildSectionTitle(
                'Fitur Aplikasi',
                Icons.featured_play_list,
                context,
              ),
              SizedBox(height: 16),
              _buildFeatureGrid(context),

              SizedBox(height: 32),

              // Contact Section
              _buildSectionTitle(
                'Kontak Support',
                Icons.contact_support,
                context,
              ),
              SizedBox(height: 16),
              _buildContactInfo(context),

              SizedBox(height: 32),

              // Tutorial Section
              _buildSectionTitle(
                'Panduan Cepat',
                Icons.play_circle_fill,
                context,
              ),
              SizedBox(height: 16),
              _buildTutorialSteps(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 20 : 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.help_center,
              size: ResponsiveLayout.isMobile(context) ? 50 : 60,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Butuh Bantuan?',
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context) ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Temukan jawaban untuk pertanyaan umum dan panduan penggunaan aplikasi GStok',
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: ResponsiveLayout.isMobile(context) ? 24 : 28,
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context) ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0, // 🔹 Hilangkan bayangan default
      color: Colors.grey.shade50, // 🔹 Warna lembut
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none, // 🔹 Hilangkan border hitam
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor:
              Colors.transparent, // 🔹 Hilangkan garis pemisah ExpansionTile
        ),
        child: ExpansionTile(
          leading: Icon(
            Icons.question_answer_rounded,
            color: AppColors.primary,
            size: ResponsiveLayout.getIconSize(context),
          ),
          title: Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveLayout.getFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 16,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: ResponsiveLayout.getFontSize(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 14,
                  ),
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final features = [
      {
        'icon': Icons.inventory,
        'title': 'Manajemen Barang',
        'desc': 'Kelola stok dan informasi barang',
      },
      {
        'icon': Icons.category,
        'title': 'Kategori',
        'desc': 'Organisir barang dengan kategori',
      },
      {
        'icon': Icons.swap_horiz,
        'title': 'Transaksi',
        'desc': 'Catat barang masuk dan keluar',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveLayout.getGridCrossAxisCount(context),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: ResponsiveLayout.isMobile(context) ? 0.8 : 1.0,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _buildFeatureCard(
          context,
          features[index]['icon'] as IconData,
          features[index]['title'] as String,
          features[index]['desc'] as String,
        );
      },
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveLayout.getIconSize(context),
              color: AppColors.primary,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveLayout.getFontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
                color: AppColors.grey800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(
                  context,
                  mobile: 12,
                  tablet: 14,
                  desktop: 14,
                ),
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildContactItem(
              context,
              Icons.email,
              'Email Support',
              'support@gstok.com',
            ),
            _buildContactItem(
              context,
              Icons.phone,
              'Telepon',
              '+62 21 1234 5678',
            ),
            _buildContactItem(
              context,
              Icons.schedule,
              'Jam Operasional',
              'Senin - Jumat, 08:00 - 17:00 WIB',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: ResponsiveLayout.getIconSize(context),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveLayout.getFontSize(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 16,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: ResponsiveLayout.getFontSize(
                      context,
                      mobile: 12,
                      tablet: 14,
                      desktop: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialSteps(BuildContext context) {
    final steps = [
      {'step': '1', 'title': 'Login', 'desc': 'Masuk dengan akun Anda'},
      {
        'step': '2',
        'title': 'Tambah Kategori',
        'desc': 'Buat kategori barang terlebih dahulu',
      },
      {
        'step': '3',
        'title': 'Tambah Barang',
        'desc': 'Input barang dengan kategori yang sesuai',
      },
      {
        'step': '4',
        'title': 'Catat Transaksi',
        'desc': 'Lakukan transaksi masuk/keluar',
      },
      {
        'step': '5',
        'title': 'Pantau Dashboard',
        'desc': 'Lihat ringkasan di dashboard',
      },
    ];

    return Column(
      children: steps.map((step) {
        return _buildTutorialStep(
          context,
          step['step']!,
          step['title']!,
          step['desc']!,
        );
      }).toList(),
    );
  }

  Widget _buildTutorialStep(
    BuildContext context,
    String step,
    String title,
    String description,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: ResponsiveLayout.isMobile(context) ? 40 : 50,
          height: ResponsiveLayout.isMobile(context) ? 40 : 50,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveLayout.isMobile(context) ? 16 : 18,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveLayout.getFontSize(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 16,
            ),
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: ResponsiveLayout.getFontSize(
              context,
              mobile: 12,
              tablet: 14,
              desktop: 14,
            ),
          ),
        ),
      ),
    );
  }
}
