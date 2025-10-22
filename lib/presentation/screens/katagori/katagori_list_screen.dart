import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/kategori_provider.dart';
import '../../../data/models/kategori_model.dart';
import '../../../core/constants/app_colors.dart';

class KategoriListScreen extends StatefulWidget {
  @override
  _KategoriListScreenState createState() => _KategoriListScreenState();
}

class _KategoriListScreenState extends State<KategoriListScreen> {
  int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  List<KatagoriModel> _filteredKategori = [];

  @override
  void initState() {
    super.initState();
    _loadKategori();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadKategori() async {
    final kategoriProvider = Provider.of<KatagoriProvider>(
      context,
      listen: false,
    );
    await kategoriProvider.loadKatagori(); // Pastikan method ini ada di provider
    setState(() {
      _filteredKategori = kategoriProvider.katagoriList;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final kategoriProvider = Provider.of<KatagoriProvider>(
      context,
      listen: false,
    );

    if (query.isEmpty) {
      setState(() {
        _filteredKategori = kategoriProvider.katagoriList;
      });
    } else {
      setState(() {
        _filteredKategori = kategoriProvider.katagoriList.where((kategori) {
          return kategori.nama.toLowerCase().contains(query) ||
              (kategori.deskripsi?.toLowerCase().contains(query) ?? false);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategoriProvider = Provider.of<KatagoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Daftar Kategori',
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari kategori...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: ResponsiveLayout.isMobile(context) ? 20 : 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveLayout.isMobile(context) ? 12 : 16,
                    vertical: ResponsiveLayout.isMobile(context) ? 10 : 12,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: kategoriProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _filteredKategori.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category,
                              size: ResponsiveLayout.isMobile(context) ? 48 : 64,
                              color: AppColors.grey400,
                            ),
                            SizedBox(
                              height: ResponsiveLayout.isMobile(context) ? 12 : 16,
                            ),
                            Text(
                              'Tidak ada kategori',
                              style: TextStyle(
                                fontSize: ResponsiveLayout.isMobile(context)
                                    ? 16
                                    : 18,
                                color: AppColors.grey600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredKategori.length,
                        itemBuilder: (context, index) {
                          final kategori = _filteredKategori[index];
                          return _buildKategoriCard(
                            context,
                            kategori,
                            kategoriProvider,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/kategori/form');
          // Reload data setelah kembali dari form
          _loadKategori();
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

  Widget _buildKategoriCard(
    BuildContext context,
    KatagoriModel kategori,
    KatagoriProvider kategoriProvider,
  ) {
    final Color cardColor = _getColorFromString(kategori.warna);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/kategori/detail', arguments: kategori);
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.getPadding(context),
          vertical: 4,
        ),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cardColor.withOpacity(0.05),
                cardColor.withOpacity(0.02),
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
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.category,
                color: cardColor,
                size: ResponsiveLayout.isMobile(context) ? 18 : 22,
              ),
            ),
            title: Text(
              kategori.nama,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deskripsi: ${kategori.deskripsi?.isNotEmpty == true ? kategori.deskripsi! : 'Tidak ada deskripsi'}',
                  style: TextStyle(
                    fontSize: ResponsiveLayout.isMobile(context) ? 10 : 12,
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: cardColor,
                size: ResponsiveLayout.isMobile(context) ? 20 : 24,
              ),
              onSelected: (value) async {
                if (value == 'edit') {
                  await Navigator.pushNamed(
                    context,
                    '/kategori/form',
                    arguments: kategori,
                  );
                  // Reload data setelah edit
                  _loadKategori();
                } else if (value == 'delete') {
                  _showDeleteDialog(context, kategori, kategoriProvider);
                } else if (value == 'detail') {
                  Navigator.pushNamed(
                    context,
                    '/kategori/detail',
                    arguments: kategori,
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: ResponsiveLayout.isMobile(context) ? 18 : 20,
                      ),
                      SizedBox(width: ResponsiveLayout.isMobile(context) ? 6 : 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: AppColors.error,
                        size: ResponsiveLayout.isMobile(context) ? 18 : 20,
                      ),
                      SizedBox(width: ResponsiveLayout.isMobile(context) ? 6 : 8),
                      Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function
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

  void _showDeleteDialog(
    BuildContext context,
    KatagoriModel kategori,
    KatagoriProvider kategoriProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Kategori',
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context) ? 16 : 18,
          ),
        ),
        content: Text('Yakin hapus ${kategori.nama}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await kategoriProvider.deleteKatagori(
                kategori.id!,
              );
              if (success) {
                // Update filtered list setelah delete
                _loadKategori();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Kategori berhasil dihapus'),
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
                      'Gagal menghapus kategori: ${kategoriProvider.error}',
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              'Hapus',
              style: TextStyle(
                fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}