import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../../data/models/transaksi_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/barang_provider.dart';

class TransaksiListScreen extends StatefulWidget {
  @override
  _TransaksiListScreenState createState() => _TransaksiListScreenState();
}

class _TransaksiListScreenState extends State<TransaksiListScreen> {
  String _filterTipe = 'Semua';
  final List<String> _tipeList = ['Semua', 'Masuk', 'Keluar'];
  DateTime? _filterTanggal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BarangProvider>(context, listen: false).loadBarangByUser();
      Provider.of<TransaksiProvider>(context, listen: false).loadTransaksi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Riwayat Transaksi',
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
        automaticallyImplyLeading: false,
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                // Filter Section
                Padding(
                  padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
                  child: Row(
                    children: [
                      // Filter Tipe
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipe Transaksi',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey700,
                                fontSize: ResponsiveLayout.isMobile(context)
                                    ? 12
                                    : 14,
                              ),
                            ),
                            SizedBox(height: 6),
                            Container(
                              height: ResponsiveLayout.isMobile(context)
                                  ? 40
                                  : 44,
                              decoration: BoxDecoration(
                                color: AppColors.grey50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.grey200),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _filterTipe,
                                  items: _tipeList.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveLayout.isMobile(context)
                                              ? 14
                                              : 16,
                                        ),
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveLayout.isMobile(
                                                  context,
                                                )
                                                ? 13
                                                : 15,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => _filterTipe = value!),
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(12),
                                  icon: Padding(
                                    padding: EdgeInsets.only(right: 12),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.grey500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: ResponsiveLayout.isMobile(context) ? 12 : 16,
                      ),

                      // Filter Tanggal
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Transaksi',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey700,
                                fontSize: ResponsiveLayout.isMobile(context)
                                    ? 12
                                    : 14,
                              ),
                            ),
                            SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _filterTanggal ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => _filterTanggal = picked);
                                }
                              },
                              child: Container(
                                height: ResponsiveLayout.isMobile(context)
                                    ? 40
                                    : 44,
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _filterTanggal == null
                                          ? "Pilih Tanggal"
                                          : _formatDate(_filterTanggal!),
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveLayout.isMobile(context)
                                            ? 13
                                            : 15,
                                        color: _filterTanggal == null
                                            ? AppColors.grey500
                                            : AppColors.grey800,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (_filterTanggal != null)
                                          GestureDetector(
                                            onTap: () => setState(
                                              () => _filterTanggal = null,
                                            ),
                                            child: Icon(
                                              Icons.clear,
                                              color: AppColors.error,
                                              size: 18,
                                            ),
                                          )
                                        else
                                          Icon(
                                            Icons.calendar_today,
                                            color: AppColors.primary,
                                            size: 18,
                                          ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Transaction List
                Expanded(
                  child: Consumer<TransaksiProvider>(
                    builder: (context, transaksiProvider, child) {
                      if (transaksiProvider.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      List<TransaksiModel> filteredTransactions =
                          transaksiProvider.transaksiList;

                      // Apply filters
                      if (_filterTipe != 'Semua') {
                        filteredTransactions = filteredTransactions
                            .where(
                              (t) =>
                                  t.tipeTransaksi.toLowerCase().trim() ==
                                  _filterTipe.toLowerCase().trim(),
                            )
                            .toList();
                      }
                      if (_filterTanggal != null) {
                        filteredTransactions = filteredTransactions.where((t) {
                          return t.tanggal.year == _filterTanggal!.year &&
                              t.tanggal.month == _filterTanggal!.month &&
                              t.tanggal.day == _filterTanggal!.day;
                        }).toList();
                      }
                      filteredTransactions.sort(
                        (a, b) => b.tanggal.compareTo(a.tanggal),
                      );

                      if (filteredTransactions.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: ResponsiveLayout.isMobile(context)
                                    ? 80
                                    : 120,
                                height: ResponsiveLayout.isMobile(context)
                                    ? 80
                                    : 120,
                                decoration: BoxDecoration(
                                  color: AppColors.grey200,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.swap_horiz_outlined,
                                  size: ResponsiveLayout.isMobile(context)
                                      ? 35
                                      : 50,
                                  color: AppColors.grey400,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Belum ada transaksi',
                                style: TextStyle(
                                  fontSize: ResponsiveLayout.isMobile(context)
                                      ? 16
                                      : 18,
                                  color: AppColors.grey600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tambahkan transaksi pertama Anda',
                                style: TextStyle(
                                  color: AppColors.grey500,
                                  fontSize: ResponsiveLayout.isMobile(context)
                                      ? 12
                                      : 14,
                                ),
                              ),
                              SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/transaksi/form',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Tambah Transaksi',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaksi = filteredTransactions[index];
                          return _buildTransactionCard(context, transaksi);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/transaksi/form');
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: ResponsiveLayout.isMobile(context) ? 24 : 28,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, TransaksiModel transaksi) {
    final isMasuk = transaksi.tipeTransaksi.toLowerCase() == 'masuk';
    final barangProvider = Provider.of<BarangProvider>(context);
    final barang = barangProvider.getBarangById(transaksi.barangId);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/transaksi/detail', arguments: transaksi);
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.getPadding(context),
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (isMasuk ? AppColors.success : AppColors.error).withOpacity(
                  0.05,
                ),
                (isMasuk ? AppColors.success : AppColors.error).withOpacity(
                  0.02,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Container(
              width: ResponsiveLayout.isMobile(context) ? 40 : 50,
              height: ResponsiveLayout.isMobile(context) ? 40 : 50,
              decoration: BoxDecoration(
                color: (isMasuk ? AppColors.success : AppColors.error)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
                color: isMasuk ? AppColors.success : AppColors.error,
                size: ResponsiveLayout.isMobile(context) ? 18 : 22,
              ),
            ),
            title: Text(
              barang?.nama ?? 'Barang Tidak Diketahui',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.grey800,
                fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah: ${transaksi.jumlah} unit',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: ResponsiveLayout.isMobile(context) ? 11 : 12,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tanggal: ${_formatDate(transaksi.tanggal)}',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: ResponsiveLayout.isMobile(context) ? 11 : 12,
                  ),
                ),
              ],
            ),
            trailing: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isMobile(context) ? 6 : 8,
                      vertical: ResponsiveLayout.isMobile(context) ? 2 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: isMasuk ? AppColors.success : AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isMasuk ? 'MASUK' : 'KELUAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: ResponsiveLayout.isMobile(context) ? 8 : 10,
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveLayout.isMobile(context) ? 4 : 6),
                  Text(
                    'Rp ${transaksi.totalHarga.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey800,
                      fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
