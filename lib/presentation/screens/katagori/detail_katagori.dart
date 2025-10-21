// katagori_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import '../../providers/kategori_provider.dart';
import '../../providers/barang_provider.dart';
import '../../../data/models/kategori_model.dart';
import '../../../data/models/barang_model.dart';
import '../../../core/constants/app_colors.dart';

class KatagoriDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! KatagoriModel) {
      Navigator.pop(context);
      return Scaffold(
        body: Center(child: Text('Data kategori tidak ditemukan')),
      );
    }

    final KatagoriModel kategori = args;
    final barangProvider = Provider.of<BarangProvider>(context);
    final kategoriProvider = Provider.of<KatagoriProvider>(context);

    // Filter barang berdasarkan kategori
    final List<BarangModel> barangDalamKategori = barangProvider.barangList
        .where((barang) => barang.katagoriId == kategori.id)
        .toList();

    final Color kategoriColor = _getColorFromString(kategori.warna);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Kategori',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: ResponsiveLayout.isMobile(context) ? 20 : 24,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveLayout.getFormWidth(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

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
                          Icons.category,
                          size: ResponsiveLayout.isMobile(context) ? 30 : 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveLayout.isMobile(context) ? 12 : 16,
                      ),
                      Text(
                        kategori.nama,
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
                          '${barangDalamKategori.length} Barang',
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

              SizedBox(height: ResponsiveLayout.isMobile(context) ? 20 : 24),

              // Informasi Kategori Section
              _buildInfoSection(context, kategori, kategoriColor),

              SizedBox(height: ResponsiveLayout.isMobile(context) ? 20 : 24),

              // Daftar Barang dalam Kategori
              _buildBarangListSection(
                context,
                kategori,
                barangDalamKategori,
                kategoriColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    KatagoriModel kategori,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 20 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: color,
                    size: ResponsiveLayout.isMobile(context) ? 20 : 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Informasi Kategori',
                  style: TextStyle(
                    fontSize: ResponsiveLayout.isMobile(context) ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Deskripsi
            if (kategori.deskripsi != null && kategori.deskripsi!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Text(
                      kategori.deskripsi!,
                      style: TextStyle(
                        fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                        color: AppColors.grey600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Barang List Section
  Widget _buildBarangListSection(
    BuildContext context,
    KatagoriModel kategori,
    List<BarangModel> barangList,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.inventory_2,
                color: color,
                size: ResponsiveLayout.isMobile(context) ? 20 : 24,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Barang dalam Kategori',
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context) ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${barangList.length}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 20),

        // Barang List atau Empty State
        barangList.isEmpty
            ? _buildEmptyState(context, kategori)
            : Column(
                children: barangList.map((barang) {
                  return _buildBarangCard(context, barang, color);
                }).toList(),
              ),
      ],
    );
  }

  // Widget untuk Barang Card
  Widget _buildBarangCard(
    BuildContext context,
    BarangModel barang,
    Color color,
  ) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveLayout.isMobile(context) ? 12 : 16,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigate to barang detail
          // Navigator.pushNamed(context, '/barang/detail', arguments: barang);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon Barang
              Container(
                width: ResponsiveLayout.isMobile(context) ? 50 : 60,
                height: ResponsiveLayout.isMobile(context) ? 50 : 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(
                  Icons.inventory_2,
                  color: color,
                  size: ResponsiveLayout.isMobile(context) ? 22 : 26,
                ),
              ),
              SizedBox(width: 16),

              // Info Barang
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barang.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveLayout.isMobile(context) ? 16 : 18,
                        color: AppColors.grey800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        _buildInfoChip(
                          'Harga : Rp ${barang.harga.toStringAsFixed(0)}',
                          AppColors.info,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Stok Indicator
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveLayout.isMobile(context) ? 12 : 16,
                  vertical: ResponsiveLayout.isMobile(context) ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: _getStokColor(barang.stok).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStokColor(barang.stok).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${barang.stok}',
                      style: TextStyle(
                        color: _getStokColor(barang.stok),
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                      ),
                    ),
                    Text(
                      'unit',
                      style: TextStyle(
                        color: _getStokColor(barang.stok),
                        fontSize: ResponsiveLayout.isMobile(context) ? 10 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Info Chip
  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, KatagoriModel kategori) {
    return Container(
      padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 32 : 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: ResponsiveLayout.isMobile(context) ? 64 : 80,
            color: AppColors.grey400,
          ),
          SizedBox(height: 20),
          Text(
            'Belum ada barang',
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Tambahkan barang baru dan pilih kategori "${kategori.nama}"',
            style: TextStyle(
              fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
              color: AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/barang/form');
            },
            icon: Icon(Icons.add),
            label: Text('Tambah Barang Baru'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  // Helper function untuk warna stok
  Color _getStokColor(int stok) {
    if (stok == 0) return AppColors.error;
    if (stok <= 10) return AppColors.warning;
    return AppColors.success;
  }
}
