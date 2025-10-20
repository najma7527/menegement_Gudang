import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/barang_provider.dart';
import '../../providers/kategori_provider.dart';
import '../../../data/models/barang_model.dart';
import '../../../core/constants/app_colors.dart';

class BarangFormScreen extends StatefulWidget {
  @override
  _BarangFormScreenState createState() => _BarangFormScreenState();
}

class _BarangFormScreenState extends State<BarangFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _stokController = TextEditingController();
  final _hargaController = TextEditingController();

  int? _selectedKatagoriId;
  BarangModel? _editingBarang;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KatagoriProvider>(context, listen: false).loadKatagori();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is BarangModel) {
      _editingBarang = args;
      _namaController.text = _editingBarang!.nama;
      _stokController.text = _editingBarang!.stok.toString();
      _hargaController.text = _editingBarang!.harga.toString();
      _selectedKatagoriId = _editingBarang!.katagoriId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);
    final katagoriProvider = Provider.of<KatagoriProvider>(context);

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

        centerTitle: true,
        title: Text(
          _editingBarang == null ? 'Tambah Barang' : 'Edit Barang',
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
      ),
      body: SingleChildScrollView(
        padding: ResponsiveLayout.getFormPadding(context), // RESPONSIVE PADDING
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveLayout.getFormWidth(
                context,
              ), // RESPONSIVE WIDTH
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nama Barang Field
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
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Barang',
                        labelStyle: TextStyle(color: AppColors.grey600),
                        prefixIcon: Icon(
                          Icons.inventory_2,
                          color: AppColors.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true)
                          return 'Nama barang harus diisi';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Kategori Dropdown
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
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        labelStyle: TextStyle(color: AppColors.grey600),
                        prefixIcon: Icon(
                          Icons.category,
                          color: AppColors.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      value: _selectedKatagoriId,
                      items: katagoriProvider.katagoriList.map((katagori) {
                        return DropdownMenuItem<int>(
                          value: katagori.id,
                          child: Text(katagori.nama),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedKatagoriId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return 'Pilih kategori';
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Stok dan Harga Row - RESPONSIVE
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
                          controller: _stokController,
                          decoration: InputDecoration(
                            labelText: 'Stok',
                            labelStyle: TextStyle(color: AppColors.grey600),
                            prefixIcon: Icon(
                              Icons.inventory,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          readOnly: _editingBarang != null,
                          validator: (value) {
                            if (value?.isEmpty ?? true)
                              return 'Stok harus diisi';
                            if (int.tryParse(value!) == null)
                              return 'Stok harus angka';
                            if (int.parse(value) < 0)
                              return 'Stok tidak boleh negatif';
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
                          controller: _hargaController,
                          decoration: InputDecoration(
                            labelText: 'Harga',
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true)
                              return 'Harga harus diisi';
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
                  SizedBox(height: 32),

                  // Save Button
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
                    child: barangProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final barang = BarangModel(
                                  id: _editingBarang?.id,
                                  nama: _namaController.text,
                                  katagoriId: _selectedKatagoriId!,
                                  stok: int.parse(_stokController.text),
                                  harga: double.parse(_hargaController.text),
                                );

                                bool success;
                                if (_editingBarang == null) {
                                  success = await barangProvider.addBarang(
                                    barang,
                                  );
                                } else {
                                  success = await barangProvider.updateBarang(
                                    _editingBarang!.id!,
                                    barang,
                                  );
                                }

                                if (success) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Barang berhasil disimpan'),
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
                                        'Gagal menyimpan barang: ${barangProvider.error}',
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
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              _editingBarang == null
                                  ? 'TAMBAH BARANG'
                                  : 'UPDATE BARANG',
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

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    super.dispose();
  }
}
