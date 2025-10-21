import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import '../../../data/models/barang_model.dart';
import '../../../data/models/kategori_model.dart';
import '../../../core/constants/app_colors.dart';

class BarangDetailScreen extends StatelessWidget {
  // Helper function untuk convert string warna ke Color
  Color _getColorFromString(String? warnaString) {
    if (warnaString == null || warnaString.isEmpty) {
      return AppColors.primary;
    }

    try {
      String hexColor = warnaString.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final BarangModel barang = args['barang'];
    final KatagoriModel kategori = args['kategori'];

    final Color kategoriColor = _getColorFromString(kategori.warna);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Barang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: ResponsiveLayout.isMobile(context) ? 20 : 24,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getFormWidth(context),
          ),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        kategoriColor.withOpacity(0.9),
                        kategoriColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(
                    ResponsiveLayout.isMobile(context) ? 16 : 24,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: ResponsiveLayout.isMobile(context) ? 60 : 80,
                        height: ResponsiveLayout.isMobile(context) ? 60 : 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.inventory_2,
                          size: ResponsiveLayout.isMobile(context) ? 30 : 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveLayout.isMobile(context) ? 12 : 16,
                      ),
                      Text(
                        barang.nama,
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 20
                              : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: ResponsiveLayout.isMobile(context) ? 6 : 8,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveLayout.isMobile(context)
                              ? 12
                              : 16,
                          vertical: ResponsiveLayout.isMobile(context) ? 6 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text(
                          barang.stok > 10 ? 'Stok Aman' : 'Stok Menipis',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 24),

              // Detail Information - TIDAK DIUBAH
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveLayout.isMobile(context) ? 16 : 24,
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        'Kategori',
                        kategori.nama,
                        Icons.category,
                        context,
                      ),
                      _buildDetailRow(
                        'Stok',
                        '${barang.stok} unit',
                        Icons.inventory,
                        context,
                      ),
                      _buildDetailRow(
                        'Harga',
                        'Rp ${barang.harga.toStringAsFixed(0)}',
                        Icons.attach_money,
                        context,
                      ),
                      if (kategori.deskripsi != null &&
                          kategori.deskripsi!.isNotEmpty)
                        _buildDetailRow(
                          'Deskripsi Kategori',
                          kategori.deskripsi!,
                          Icons.description,
                          context,
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 24),

              // Statistics Card - TIDAK DIUBAH
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveLayout.isMobile(context) ? 16 : 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistik Barang',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 16
                              : 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey800,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveLayout.isMobile(context) ? 12 : 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            'Nilai Total',
                            'Rp ${(barang.harga * barang.stok).toStringAsFixed(0)}',
                            Icons.assessment,
                            context,
                          ),
                          _buildStatItem(
                            'Status stok',
                            barang.stok > 10 ? 'Aman' : 'Waspada',
                            barang.stok > 10
                                ? Icons.check_circle
                                : Icons.warning,
                            context,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveLayout.isMobile(context) ? 8 : 12,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 6 : 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: ResponsiveLayout.isMobile(context) ? 16 : 20,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: ResponsiveLayout.isMobile(context) ? 12 : 16),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.grey600,
                fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: AppColors.grey800,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 8 : 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: ResponsiveLayout.isMobile(context) ? 20 : 24,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: ResponsiveLayout.isMobile(context) ? 6 : 8),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context) ? 10 : 12,
            color: AppColors.grey600,
          ),
        ),
        SizedBox(height: ResponsiveLayout.isMobile(context) ? 2 : 4),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: AppColors.grey800,
          ),
        ),
      ],
    );
  }
}
