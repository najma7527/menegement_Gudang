import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../../data/models/transaksi_model.dart';
import '../../providers/barang_provider.dart';
import '../../../core/constants/app_colors.dart';

class TransaksiDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TransaksiModel;
    final transaksi = args;

    final barangProvider = Provider.of<BarangProvider>(context);
    final barang = barangProvider.getBarangById(transaksi.barangId);

    final isMasuk = transaksi.tipeTransaksi.toLowerCase() == 'masuk';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Transaksi',
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
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (isMasuk ? AppColors.success : AppColors.error)
                            .withOpacity(0.1),
                        (isMasuk ? AppColors.success : AppColors.error)
                            .withOpacity(0.05),
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
                          color: (isMasuk ? AppColors.success : AppColors.error)
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
                          size: ResponsiveLayout.isMobile(context) ? 30 : 40,
                          color: isMasuk ? AppColors.success : AppColors.error,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveLayout.isMobile(context) ? 12 : 16,
                      ),
                      Text(
                        isMasuk ? 'BARANG MASUK' : 'BARANG KELUAR',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 16
                              : 20,
                          fontWeight: FontWeight.bold,
                          color: isMasuk ? AppColors.success : AppColors.error,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveLayout.isMobile(context) ? 6 : 8,
                      ),
                      Text(
                        barang?.nama ?? 'Barang Tidak Diketahui',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context)
                              ? 14
                              : 18,
                          color: AppColors.grey700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 24),

              // Detail Information
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
                        'Barang',
                        barang?.nama ?? '-',
                        Icons.inventory_2,
                        context,
                      ),
                      _buildDetailRow(
                        'Tipe Transaksi',
                        isMasuk ? 'Barang Masuk' : 'Barang Keluar',
                        Icons.swap_horiz,
                        context,
                      ),
                      _buildDetailRow(
                        'Jumlah',
                        '${transaksi.jumlah} unit',
                        Icons.format_list_numbered,
                        context,
                      ),
                      _buildDetailRow(
                        'Harga Satuan',
                        'Rp ${transaksi.hargaSatuan.toStringAsFixed(0)}',
                        Icons.attach_money,
                        context,
                      ),
                      _buildDetailRow(
                        'Tanggal',
                        '${transaksi.tanggal.day}/${transaksi.tanggal.month}/${transaksi.tanggal.year}',
                        Icons.calendar_today,
                        context,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 24),

              // Additional Info Card
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
                        'Informasi Tambahan',
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
                          _buildInfoItem(
                            'Status Stok Terkini',
                            barang?.stok.toString() ?? '-',
                            Icons.inventory,
                            AppColors.primary,
                            context,
                          ),
                          _buildInfoItem(
                            'Total transaksi',
                            'Rp ${transaksi.totalHarga.toStringAsFixed(0)}',
                            Icons.assessment,
                            isMasuk ? AppColors.success : AppColors.error,
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

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveLayout.isMobile(context) ? 8 : 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: ResponsiveLayout.isMobile(context) ? 20 : 24,
            color: color,
          ),
        ),
        SizedBox(height: ResponsiveLayout.isMobile(context) ? 6 : 8),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context) ? 10 : 12,
            color: AppColors.grey600,
            fontWeight: FontWeight.w600,
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
