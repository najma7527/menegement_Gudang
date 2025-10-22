// katagori_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/kategori_provider.dart';
import '../../providers/auth_provider.dart'; // IMPORT AuthProvider
import '../../../data/models/kategori_model.dart';
import '../../../core/constants/app_colors.dart';

class KatagoriFormScreen extends StatefulWidget {
  @override
  _KatagoriFormScreenState createState() => _KatagoriFormScreenState();
}

class _KatagoriFormScreenState extends State<KatagoriFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  KatagoriModel? _editingKatagori;
  int _deskripsiLength = 0;
  Color _selectedColor = AppColors.primary;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _deskripsiController.addListener(_updateDeskripsiLength);
  }

  void _updateDeskripsiLength() {
    setState(() {
      _deskripsiLength = _deskripsiController.text.length;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _initializeData();
      _isInitialized = true;
    }
  }

  void _initializeData() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is KatagoriModel) {
      _editingKatagori = args;
      _namaController.text = _editingKatagori!.nama;
      _deskripsiController.text = _editingKatagori!.deskripsi ?? '';
      _deskripsiLength = _deskripsiController.text.length;

      if (_editingKatagori!.warna != null &&
          _editingKatagori!.warna!.isNotEmpty) {
        _selectedColor = _parseColor(_editingKatagori!.warna!);
      }
    }
  }

  Color _parseColor(String colorString) {
    try {
      String hexColor = colorString.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }

  String _colorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  void _openMaterialColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Warna Kategori'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.of(context).pop();
              },
              enableLabel: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // METHOD BARU: Validasi dan persiapan data sebelum submit
  Future<void> _submitForm() async {
    if (_deskripsiLength > 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deskripsi terlalu panjang. Maksimal 200 karakter.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final katagoriProvider = Provider.of<KatagoriProvider>(
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

    final katagori = KatagoriModel(
      id: _editingKatagori?.id,
      nama: _namaController.text,
      deskripsi: _deskripsiController.text.isEmpty
          ? null
          : _deskripsiController.text,
      warna: _colorToString(_selectedColor),
      UserId: currentUserId, // GUNAKAN USER ID YANG SESUNGGUHNYA
    );

    print('DATA KIRIM: ${katagori.toJson()}'); // Debug print

    bool success;
    if (_editingKatagori == null) {
      success = await katagoriProvider.addKatagori(katagori);
    } else {
      success = await katagoriProvider.updateKatagori(
        _editingKatagori!.id!,
        katagori,
      );
    }

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kategori berhasil disimpan'),
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
            'Gagal menyimpan kategori: ${katagoriProvider.error ?? "Unknown error"}',
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

  @override
  Widget build(BuildContext context) {
    final katagoriProvider = Provider.of<KatagoriProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

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
          _editingKatagori == null ? 'Tambah Kategori' : 'Edit Kategori',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Kategori Field
              Text(
                'Nama Kategori *',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true)
                    return 'Nama kategori harus diisi';
                  if (value!.length < 2)
                    return 'Nama kategori minimal 2 karakter';
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Color Picker Section
              Text(
                'Warna Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              SizedBox(height: 8),

              InkWell(
                onTap: _openMaterialColorPicker,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    children: [
                      // Color Preview
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.grey400),
                        ),
                      ),
                      SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Warna Kategori',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _colorToString(_selectedColor).toUpperCase(),
                              style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(Icons.color_lens, color: _selectedColor, size: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Klik untuk memilih warna yang berbeda',
                style: TextStyle(color: AppColors.grey500, fontSize: 12),
              ),

              SizedBox(height: 20),

              // Deskripsi Field
              Text(
                'Deskripsi Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                maxLength: 200,
                decoration: InputDecoration(
                  hintText: 'Deskripsi optional tentang kategori ini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Panjang deskripsi:',
                    style: TextStyle(color: AppColors.grey600, fontSize: 12),
                  ),
                  Text(
                    '$_deskripsiLength/200 karakter',
                    style: TextStyle(
                      color: _deskripsiLength > 200
                          ? AppColors.error
                          : AppColors.grey600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Save Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (katagoriProvider.isLoading ||
                          !authProvider.isAuthenticated)
                      ? null
                      : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: katagoriProvider.isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _editingKatagori == null
                              ? 'SIMPAN KATEGORI'
                              : 'UPDATE KATEGORI',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                      Icon(Icons.warning, size: 16, color: AppColors.warning),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Anda harus login untuk menyimpan kategori',
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }
}
