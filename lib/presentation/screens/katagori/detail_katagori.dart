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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card dengan warna kategori
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _getColorFromString(kategori.warna).withOpacity(0.9),
                        _getColorFromString(kategori.warna).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(
                    ResponsiveLayout.isMobile(context) ? 20 : 24,
                  ),
                  child: Column(
                    children: [
                      // Icon Kategori
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
                        height: ResponsiveLayout.isMobile(context) ? 16 : 20,
                      ),

                      // Nama Kategori
                      Text(
                        kategori.nama,
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 24
                              : 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(
                        height: ResponsiveLayout.isMobile(context) ? 8 : 12,
                      ),

                      // Jumlah Barang
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveLayout.isMobile(context)
                              ? 16
                              : 20,
                          vertical: ResponsiveLayout.isMobile(context) ? 6 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${barangDalamKategori.length} Barang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveLayout.isMobile(context)
                                ? 14
                                : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ResponsiveLayout.isMobile(context) ? 20 : 24),

              // Deskripsi Kategori
              if (kategori.deskripsi != null && kategori.deskripsi!.isNotEmpty)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      ResponsiveLayout.isMobile(context) ? 16 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: AppColors.primary,
                              size: ResponsiveLayout.isMobile(context)
                                  ? 18
                                  : 22,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Deskripsi Kategori',
                              style: TextStyle(
                                fontSize: ResponsiveLayout.isMobile(context)
                                    ? 16
                                    : 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey800,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveLayout.isMobile(context) ? 8 : 12,
                        ),
                        Text(
                          kategori.deskripsi!,
                          style: TextStyle(
                            fontSize: ResponsiveLayout.isMobile(context)
                                ? 14
                                : 16,
                            color: AppColors.grey600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: ResponsiveLayout.isMobile(context) ? 20 : 24),

              // Daftar Barang dalam Kategori
              Row(
                children: [
                  Icon(
                    Icons.inventory_2,
                    color: AppColors.primary,
                    size: ResponsiveLayout.isMobile(context) ? 18 : 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Barang dalam Kategori',
                    style: TextStyle(
                      fontSize: ResponsiveLayout.isMobile(context) ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveLayout.isMobile(context) ? 12 : 16),

              barangDalamKategori.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(
                        ResponsiveLayout.isMobile(context) ? 24 : 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: ResponsiveLayout.isMobile(context) ? 48 : 64,
                            color: AppColors.grey400,
                          ),
                          SizedBox(
                            height: ResponsiveLayout.isMobile(context)
                                ? 12
                                : 16,
                          ),
                          Text(
                            'Tidak ada barang dalam kategori ini',
                            style: TextStyle(
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? 16
                                  : 18,
                              color: AppColors.grey600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: ResponsiveLayout.isMobile(context) ? 8 : 12,
                          ),
                          Text(
                            'Tambahkan barang baru dan pilih kategori "${kategori.nama}"',
                            style: TextStyle(
                              fontSize: ResponsiveLayout.isMobile(context)
                                  ? 12
                                  : 14,
                              color: AppColors.grey500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: barangDalamKategori.map((barang) {
                        return Card(
                          margin: EdgeInsets.only(
                            bottom: ResponsiveLayout.isMobile(context) ? 8 : 12,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: ResponsiveLayout.isMobile(context)
                                  ? 40
                                  : 50,
                              height: ResponsiveLayout.isMobile(context)
                                  ? 40
                                  : 50,
                              decoration: BoxDecoration(
                                color: _getColorFromString(
                                  kategori.warna,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.inventory_2,
                                color: _getColorFromString(kategori.warna),
                                size: ResponsiveLayout.isMobile(context)
                                    ? 18
                                    : 22,
                              ),
                            ),
                            title: Text(
                              barang.nama,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveLayout.isMobile(context)
                                    ? 14
                                    : 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Text(
                                  'Stok: ${barang.stok} unit',
                                  style: TextStyle(
                                    fontSize: ResponsiveLayout.isMobile(context)
                                        ? 12
                                        : 14,
                                    color: barang.stok > 10
                                        ? AppColors.success
                                        : AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Harga: Rp ${barang.harga.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: ResponsiveLayout.isMobile(context)
                                        ? 12
                                        : 14,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveLayout.isMobile(context)
                                    ? 8
                                    : 12,
                                vertical: ResponsiveLayout.isMobile(context)
                                    ? 4
                                    : 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getColorFromString(
                                  kategori.warna,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getColorFromString(
                                    kategori.warna,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                '${barang.stok}',
                                style: TextStyle(
                                  color: _getColorFromString(kategori.warna),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveLayout.isMobile(context)
                                      ? 12
                                      : 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function untuk convert string warna ke Color
  Color _getColorFromString(String? warnaString) {
    if (warnaString == null || warnaString.isEmpty) {
      return AppColors.primary; // Warna default
    }

    try {
      // Format: "0xFF<hex>" atau "#<hex>"
      String hexColor = warnaString.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return AppColors.primary; // Fallback color
    }
  }
}
