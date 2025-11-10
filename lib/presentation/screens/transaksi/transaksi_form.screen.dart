import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/transaksi_provider.dart';
import '../../providers/barang_provider.dart';
import '../../providers/auth_provider.dart'; // TAMBAHKAN IMPORT
import '../../../data/models/transaksi_model.dart';
import '../../../data/models/barang_model.dart';
import '../../../core/constants/app_colors.dart';

class TransaksiFormScreen extends StatefulWidget {
  @override
  _TransaksiFormScreenState createState() => _TransaksiFormScreenState();
}

class _TransaksiFormScreenState extends State<TransaksiFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();
  final _hargaSatuanController = TextEditingController();

  TransaksiModel? _editingTransaksi;
  BarangModel? _selectedBarang;
  String _selectedTipe = 'masuk';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BarangProvider>(context, listen: false).loadBarangByUser();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is TransaksiModel) {
      _editingTransaksi = args;
      _jumlahController.text = _editingTransaksi!.jumlah.toString();
      _hargaSatuanController.text = _editingTransaksi!.hargaSatuan.toString();
      _selectedTipe = _editingTransaksi!.tipeTransaksi;
      _selectedDate = _editingTransaksi!.tanggal;

      // Load barang data for editing
      final barangProvider = Provider.of<BarangProvider>(
        context,
        listen: false,
      );
      _selectedBarang = barangProvider.getBarangById(
        _editingTransaksi!.barangId,
      );
    }
  }

  void _calculateTotal() {
    if (_jumlahController.text.isNotEmpty &&
        _hargaSatuanController.text.isNotEmpty) {
      final jumlah = int.tryParse(_jumlahController.text) ?? 0;
      final hargaSatuan = double.tryParse(_hargaSatuanController.text) ?? 0;
      final total = jumlah * hargaSatuan;

      // Update UI jika perlu menampilkan total
      setState(() {});
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // METHOD BARU: Validasi dan submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedBarang != null) {
      final transaksiProvider = Provider.of<TransaksiProvider>(
        context,
        listen: false,
      );
      final barangProvider = Provider.of<BarangProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // DAPATKAN USER ID DARI AUTH PROVIDER
      final currentUserId = authProvider.currentUser?.id;

      // VALIDASI: Pastikan user ID tidak null dan user sudah login
      if (currentUserId == null || !authProvider.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: User tidak terautentikasi. Silakan login kembali.',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      final jumlah = int.parse(_jumlahController.text);
      final hargaSatuan = double.parse(_hargaSatuanController.text);
      final totalHarga = jumlah * hargaSatuan;

      final transaksi = TransaksiModel(
        id: _editingTransaksi?.id,
        barangId: _selectedBarang!.id!,
        jumlah: jumlah,
        totalHarga: totalHarga,
        tipeTransaksi: _selectedTipe,
        hargaSatuan: hargaSatuan,
        tanggal: _selectedDate,
        UserId: currentUserId, 
      );

      print('DATA TRANSAKSI KIRIM: ${transaksi.toJson()}'); // Debug print

      bool success;
      if (_editingTransaksi == null) {
        success = await transaksiProvider.addTransaksi(
          transaksi,
          updateStokCallback: (barangId, jumlah, tipe) async {
            return await barangProvider.updateStokBarang(
              barangId,
              jumlah,
              tipe,
            );
          },
        );
      } else {
        success = await transaksiProvider.updateTransaksi(
          _editingTransaksi!.id!,
          transaksi,
        );
      }

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingTransaksi == null
                  ? 'Transaksi berhasil ditambahkan'
                  : 'Transaksi berhasil diupdate',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menyimpan transaksi: ${transaksiProvider.error ?? "Unknown error"}',
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaksiProvider = Provider.of<TransaksiProvider>(context);
    final barangProvider = Provider.of<BarangProvider>(context);
    final authProvider = Provider.of<AuthProvider>(
      context,
    ); // TAMBAHKAN AUTH PROVIDER

    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    final hargaSatuan = double.tryParse(_hargaSatuanController.text) ?? 0;
    final totalHarga = jumlah * hargaSatuan;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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

        title: Text(
          _editingTransaksi == null ? 'Tambah Transaksi' : 'Edit Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: ResponsiveLayout.getFormPadding(context),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveLayout.getFormWidth(context),
            ),
            child: Form(
              key: _formKey,
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
                            AppColors.primary.withOpacity(0.1),
                            AppColors.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Transaksi masuk menambah stok, transaksi keluar mengurangi stok',
                              style: TextStyle(
                                color: AppColors.grey700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Barang Dropdown - RESPONSIVE
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<BarangModel>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Pilih Barang',
                        labelStyle: TextStyle(color: AppColors.grey600),
                        prefixIcon: Icon(
                          Icons.inventory_2,
                          color: AppColors.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      value: _selectedBarang,
                      items: barangProvider.barangList.map((barang) {
                        return DropdownMenuItem<BarangModel>(
                          value: barang,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                barang.nama,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (BarangModel? value) {
                        setState(() {
                          _selectedBarang = value;
                          if (value != null) {
                            _hargaSatuanController.text = value.harga
                                .toString();
                            _calculateTotal();
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null)
                          return 'Pilih barang terlebih dahulu';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  ResponsiveRow(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Tipe Transaksi',
                            labelStyle: TextStyle(color: AppColors.grey600),
                            prefixIcon: Icon(
                              Icons.swap_horiz,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          value: _selectedTipe,
                          items: [
                            DropdownMenuItem(
                              value: 'masuk',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_downward,
                                    color: AppColors.success,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Barang Masuk',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'keluar',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_upward,
                                    color: AppColors.error,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Barang Keluar',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedTipe = value!;
                            });
                          },
                        ),
                      ),
                      // Tanggal
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
                            labelStyle: TextStyle(color: AppColors.grey600),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          controller: TextEditingController(
                            text:
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Jumlah dan Harga Satuan Row - RESPONSIVE
                  ResponsiveRow(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _jumlahController,
                          decoration: InputDecoration(
                            labelText: 'Jumlah',
                            labelStyle: TextStyle(color: AppColors.grey600),
                            prefixIcon: Icon(
                              Icons.format_list_numbered,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _calculateTotal(),
                          validator: (value) {
                            if (value?.isEmpty ?? true)
                              return 'Jumlah harus diisi';
                            if (int.tryParse(value!) == null)
                              return 'Jumlah harus angka';
                            if (int.parse(value) <= 0)
                              return 'Jumlah harus lebih dari 0';

                            // Validasi stok untuk transaksi keluar
                            if (_selectedTipe == 'keluar' &&
                                _selectedBarang != null) {
                              if (int.parse(value) > _selectedBarang!.stok) {
                                return 'Stok tidak mencukupi. Stok tersedia: ${_selectedBarang!.stok}';
                              }
                            }

                            return null;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _hargaSatuanController,
                          decoration: InputDecoration(
                            labelText: 'Harga Satuan',
                            labelStyle: TextStyle(color: AppColors.grey600),
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) => _calculateTotal(),
                          validator: (value) {
                            if (value?.isEmpty ?? true)
                              return 'Harga satuan harus diisi';
                            if (double.tryParse(value!) == null)
                              return 'Harga harus angka';
                            if (double.parse(value) <= 0)
                              return 'Harga harus lebih dari 0';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Total Harga Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Harga:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey800,
                            ),
                          ),
                          Text(
                            'Rp ${totalHarga.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Info Stok Setelah Transaksi
                  if (_selectedBarang != null &&
                      _jumlahController.text.isNotEmpty)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              _selectedTipe == 'masuk'
                                  ? Icons.add_circle_outline
                                  : Icons.remove_circle_outline,
                              color: _selectedTipe == 'masuk'
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stok setelah transaksi:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  Text(
                                    '${_calculateStokAfterTransaction()} unit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Pesan error jika user tidak terautentikasi
                  if (!authProvider.isAuthenticated) ...[
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.warning),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning,
                            size: 16,
                            color: AppColors.warning,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Anda harus login untuk menyimpan transaksi',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 32),

                  // Save Button - RESPONSIVE
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: transaksiProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : ElevatedButton(
                            onPressed:
                                (transaksiProvider.isLoading ||
                                    !authProvider.isAuthenticated)
                                ? null
                                : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _editingTransaksi == null
                                  ? 'SIMPAN TRANSAKSI'
                                  : 'UPDATE TRANSAKSI',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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

  int _calculateStokAfterTransaction() {
    if (_selectedBarang == null || _jumlahController.text.isEmpty) {
      return _selectedBarang?.stok ?? 0;
    }

    final jumlah = int.parse(_jumlahController.text);
    if (_selectedTipe == 'masuk') {
      return _selectedBarang!.stok + jumlah;
    } else {
      return _selectedBarang!.stok - jumlah;
    }
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _hargaSatuanController.dispose();
    super.dispose();
  }
}
