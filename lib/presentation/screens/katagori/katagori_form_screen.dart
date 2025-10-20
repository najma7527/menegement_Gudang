// katagori_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/kategori_provider.dart';
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

  // SOLUSI: Gunakan pendekatan yang lebih sederhana dan terpercaya
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Warna Kategori'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                // Langsung update state ketika warna berubah
                setState(() {
                  _selectedColor = color;
                });
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: false,
              pickerAreaBorderRadius: BorderRadius.circular(16),
              hexInputBar: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Reset ke Default'),
              onPressed: () {
                setState(() {
                  _selectedColor = AppColors.primary;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ALTERNATIF: Gunakan BlockPicker yang lebih sederhana
  void _openBlockColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Warna Kategori'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.of(context).pop(); // Otomatis tutup setelah pilih
              },
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

  // ALTERNATIF 2: Gunakan Material Color Picker
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

  @override
  Widget build(BuildContext context) {
    final katagoriProvider = Provider.of<KatagoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () async {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Konfirmasi"),
                  ],
                ),
                content: Text(
                  "Apakah Anda yakin ingin keluar? Perubahan yang belum disimpan akan hilang.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Ya, Keluar"),
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

              // Color Picker Section - VERSI SEDERHANA
              Text(
                'Warna Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey700,
                ),
              ),
              SizedBox(height: 8),

              // Container untuk color picker yang bisa diklik
              InkWell(
                onTap:
                    _openBlockColorPicker, // Coba ganti dengan _openMaterialColorPicker jika masih tidak bekerja
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
                decoration: InputDecoration(
                  hintText: 'Deskripsi optional tentang kategori ini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                          ? Colors.red
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
                  onPressed: _deskripsiLength > 200
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final katagori = KatagoriModel(
                              id: _editingKatagori?.id,
                              nama: _namaController.text,
                              deskripsi: _deskripsiController.text.isEmpty
                                  ? null
                                  : _deskripsiController.text,
                              warna: _colorToString(_selectedColor),
                            );

                            bool success;
                            if (_editingKatagori == null) {
                              success = await katagoriProvider.addKatagori(
                                katagori,
                              );
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
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Gagal menyimpan kategori: ${katagoriProvider.error}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
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
